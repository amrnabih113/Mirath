/**
 * Annotation Engine
 * - Single implementation (no duplicate overrides)
 * - Highlight background with alpha, text style unchanged
 * - Metadata-based selection/restore (xpath + offsets + context)
 * - Search engine preserved
 */

(function () {
  'use strict';

  const CONFIG = {
    clearSelectionAfterHighlight: true,
    debounceDelay: 120,
    contextWordWindow: 8,
  };

  let THEME_COLORS = {
    primaryColor: '#B9A082',
    backgroundColor: '#FFFDF8',
    textColor: '#000000',
    borderColor: '#D5C6B4',
  };

  const Utils = {
    escapeRegExp(text) {
      return String(text || '').replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    },

    fragmentToHtml(fragment) {
      const container = document.createElement('div');
      container.appendChild(fragment.cloneNode(true));
      return container.innerHTML;
    },

    htmlToPlainText(value) {
      const html = String(value || '').trim();
      if (!html) return '';
      const container = document.createElement('div');
      container.innerHTML = html;
      return this.normalizeWhitespace(container.textContent || '');
    },

    withAlpha(hex, alpha = 0.35) {
      const clean = String(hex || '').replace('#', '');
      if (!/^[0-9a-fA-F]{6}$/.test(clean)) {
        return `rgba(255, 235, 59, ${alpha})`;
      }
      const r = parseInt(clean.slice(0, 2), 16);
      const g = parseInt(clean.slice(2, 4), 16);
      const b = parseInt(clean.slice(4, 6), 16);
      return `rgba(${r}, ${g}, ${b}, ${Math.max(0, Math.min(1, alpha))})`;
    },

    normalizeNodeForXPath(node) {
      if (!node) return null;
      return node.nodeType === Node.TEXT_NODE ? node.parentNode : node;
    },

    getXPath(node) {
      const normalized = this.normalizeNodeForXPath(node);
      if (!normalized || normalized.nodeType !== Node.ELEMENT_NODE) return '';
      if (normalized === document.body) return '/html/body';
      if (normalized.id) return `//*[@id="${normalized.id}"]`;

      let index = 1;
      let sibling = normalized.previousElementSibling;
      while (sibling) {
        if (sibling.tagName === normalized.tagName) index += 1;
        sibling = sibling.previousElementSibling;
      }

      const parentPath = this.getXPath(normalized.parentNode);
      return `${parentPath}/${normalized.tagName}[${index}]`;
    },

    getNodeByXPath(path) {
      if (!path) return null;
      try {
        return document.evaluate(path, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
      } catch (_) {
        return null;
      }
    },

    getTextNodesInElement(element) {
      if (!element) return [];
      const nodes = [];
      const walker = document.createTreeWalker(element, NodeFilter.SHOW_TEXT, null);
      let current;
      while ((current = walker.nextNode())) {
        if ((current.textContent || '').length > 0) nodes.push(current);
      }
      return nodes;
    },

    isInMathElement(node) {
      if (!node) return false;
      let parent = node.nodeType === Node.TEXT_NODE ? node.parentNode : node;
      while (parent && parent !== document.body) {
        const tag = parent.tagName?.toLowerCase() || '';
        const type = parent.getAttribute?.('type') || '';
        // Check for math elements: script[type*="math"], <math>, katex class, etc
        if (tag === 'script' && (type.includes('math') || type.includes('tex'))) return true;
        if (tag === 'math') return true;
        if (tag === 'annotation') return true;
        if (parent.classList?.contains('math')) return true;
        if (parent.classList?.contains('katex')) return true;
        if (parent.classList?.contains('equation')) return true;
        if (tag === 'mjx-container') return true;
        if (tag === 'svg' && parent.parentNode?.classList?.contains('katex')) return true;
        parent = parent.parentNode;
      }
      return false;
    },

    resolveTextNodeFromElementAndOffset(element, charOffset) {
      const textNodes = this.getTextNodesInElement(element);
      if (textNodes.length === 0) return null;

      const safeOffset = Math.max(0, Number(charOffset) || 0);
      let walked = 0;
      for (const textNode of textNodes) {
        const len = (textNode.textContent || '').length;
        if (safeOffset <= walked + len) {
          return { node: textNode, offset: Math.max(0, Math.min(len, safeOffset - walked)) };
        }
        walked += len;
      }

      const last = textNodes[textNodes.length - 1];
      return { node: last, offset: (last.textContent || '').length };
    },

    getNodeTextOffset(elementNode, targetNode, targetOffset) {
      const textNodes = this.getTextNodesInElement(elementNode);
      let walked = 0;
      for (const textNode of textNodes) {
        if (textNode === targetNode) {
          return walked + Math.max(0, targetOffset || 0);
        }
        walked += (textNode.textContent || '').length;
      }
      return Math.max(0, targetOffset || 0);
    },

    getWords(text) {
      return String(text || '').trim().split(/\s+/).filter(Boolean);
    },

    getTextContext(fullText, start, end, windowSize) {
      const safeText = String(fullText || '');
      const before = safeText.slice(Math.max(0, start - 400), start);
      const after = safeText.slice(end, Math.min(safeText.length, end + 400));
      const beforeWords = this.getWords(before).slice(-windowSize).join(' ');
      const afterWords = this.getWords(after).slice(0, windowSize).join(' ');
      return { beforeWords, afterWords };
    },

    makeSelectable(root = document.body) {
      if (!root) return;
      root.style.userSelect = 'text';
      root.style.webkitUserSelect = 'text';
      const all = root.querySelectorAll('*');
      all.forEach((el) => {
        el.style.userSelect = 'text';
        el.style.webkitUserSelect = 'text';
      });
    },

    normalizeWhitespace(value) {
      return String(value || '').replace(/\s+/g, ' ').trim();
    },

    normalizeToken(value) {
      return String(value || '')
        .toLowerCase()
        .replace(/[^\p{L}\p{N}]+/gu, '')
        .trim();
    },

    tokenizeWords(value) {
      const words = String(value || '').match(/\S+/g) || [];
      return words.map((word) => this.normalizeToken(word)).filter(Boolean);
    },

    buildDocumentTokenIndex(root = document.body) {
      const tokens = [];
      const walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, {
        acceptNode(node) {
          const text = node.textContent || '';
          return text.trim().length === 0
            ? NodeFilter.FILTER_REJECT
            : NodeFilter.FILTER_ACCEPT;
        },
      });

      let node;
      while ((node = walker.nextNode())) {
        const text = node.textContent || '';
        const regex = /\S+/g;
        let match;

        while ((match = regex.exec(text)) !== null) {
          const raw = match[0];
          const normalized = this.normalizeToken(raw);
          if (!normalized) continue;

          tokens.push({
            normalized,
            raw,
            node,
            startOffset: match.index,
            endOffset: match.index + raw.length,
          });
        }
      }

      return tokens;
    },

    jaccardSimilarity(firstTokens, secondTokens) {
      const firstSet = new Set((firstTokens || []).filter(Boolean));
      const secondSet = new Set((secondTokens || []).filter(Boolean));
      if (firstSet.size === 0 || secondSet.size === 0) return 0;

      let intersection = 0;
      firstSet.forEach((token) => {
        if (secondSet.has(token)) intersection += 1;
      });

      const union = firstSet.size + secondSet.size - intersection;
      return union === 0 ? 0 : intersection / union;
    },

    tokensToRange(startToken, endToken) {
      if (!startToken || !endToken) return null;
      try {
        const range = document.createRange();
        range.setStart(startToken.node, startToken.startOffset);
        range.setEnd(endToken.node, endToken.endOffset);
        return range.collapsed ? null : range;
      } catch (_) {
        return null;
      }
    },

    uniqueNonEmptyStrings(values) {
      const seen = new Set();
      const result = [];
      (values || []).forEach((value) => {
        const normalized = this.normalizeWhitespace(value);
        if (!normalized) return;
        const key = normalized.toLowerCase();
        if (seen.has(key)) return;
        seen.add(key);
        result.push(normalized);
      });
      return result;
    },
  };

  const MathSupport = {
    init() {
      const style = document.createElement('style');
      style.id = 'annotation-engine-style';
      style.textContent = `
        * {
          user-select: text !important;
          -webkit-user-select: text !important;
        }

        .MathJax, .MathJax *, .katex, .katex *, mjx-container, mjx-container *, svg, svg * {
          user-select: text !important;
          -webkit-user-select: text !important;
        }

        .annotation-highlight {
          color: inherit !important;
          -webkit-text-fill-color: currentColor !important;
          fill: currentColor !important;
          stroke: inherit !important;
          border-radius: 2px;
          padding: 0 1px;
          cursor: pointer;
        }
      `;
      document.head.appendChild(style);
      Utils.makeSelectable();
    },

    retypeset(target = null) {
      if (typeof MathJax === 'undefined' || !MathJax.typesetPromise) return;
      MathJax.typesetPromise([target || document.body]).catch(() => {});
    },
  };

  const HighlightEngine = {
    highlights: new Map(),
    lastLiveRange: null,
    lastLiveText: '',

    setLastLiveSelection(range, text) {
      if (!range || range.collapsed) return;
      try {
        this.lastLiveRange = range.cloneRange();
        this.lastLiveText = Utils.normalizeWhitespace(text || range.toString() || '');
      } catch (_) {
        this.lastLiveRange = null;
        this.lastLiveText = '';
      }
    },

    getLastLiveRangeCandidate(targetText) {
      if (!this.lastLiveRange) return null;
      try {
        const candidate = this.lastLiveRange.cloneRange();
        if (candidate.collapsed) return null;

        const candidateText = Utils.normalizeWhitespace(candidate.toString());
        if (!candidateText) return null;

        const normalizedTarget = Utils.normalizeWhitespace(targetText || '');
        if (!normalizedTarget) return candidate;

        const targetTokens = Utils.tokenizeWords(normalizedTarget);
        const candidateTokens = Utils.tokenizeWords(candidateText);
        const score = Utils.jaccardSimilarity(targetTokens, candidateTokens);
        return score >= 0.2 ? candidate : null;
      } catch (_) {
        return null;
      }
    },

    buildMetadataFromRange(range, selectedText) {
      const startElement = Utils.normalizeNodeForXPath(range.startContainer);
      const endElement = Utils.normalizeNodeForXPath(range.endContainer);
      if (!startElement || !endElement) return null;

      const startOffsetInNode = range.startContainer.nodeType === Node.TEXT_NODE ? range.startOffset : 0;
      const endOffsetInNode = range.endContainer.nodeType === Node.TEXT_NODE ? range.endOffset : 0;

      const startOffset = Utils.getNodeTextOffset(startElement, range.startContainer, startOffsetInNode);
      const endOffset = Utils.getNodeTextOffset(endElement, range.endContainer, endOffsetInNode);

      const commonText = range.commonAncestorContainer.textContent || '';
      const textIndex = commonText.indexOf(selectedText);
      const context = Utils.getTextContext(
        commonText,
        Math.max(0, textIndex),
        Math.max(0, textIndex + selectedText.length),
        CONFIG.contextWordWindow,
      );
      const selectedWords = Utils.getWords(selectedText);
      const firstWord = selectedWords.length > 0
        ? Utils.normalizeToken(selectedWords[0])
        : null;
      const lastWord = selectedWords.length > 0
        ? Utils.normalizeToken(selectedWords[selectedWords.length - 1])
        : null;

      return {
        xpathStart: Utils.getXPath(startElement),
        xpathEnd: Utils.getXPath(endElement),
        startOffset,
        endOffset,
        plainText: selectedText,
        htmlContent: Utils.fragmentToHtml(range.cloneContents()),
        contextBefore: context.beforeWords,
        contextAfter: context.afterWords,
        wordCount: Utils.getWords(selectedText).length,
        selectedWordCount: selectedWords.length,
        selectedCharLength: selectedText.length,
        firstWord,
        lastWord,
      };
    },

    createRangeFromMetadata(metadata) {
      if (!metadata || !metadata.xpathStart || !metadata.xpathEnd) return null;
      const startElement = Utils.getNodeByXPath(metadata.xpathStart);
      const endElement = Utils.getNodeByXPath(metadata.xpathEnd);
      if (!startElement || !endElement) return null;

      const startResolved = Utils.resolveTextNodeFromElementAndOffset(startElement, metadata.startOffset || 0);
      const endResolved = Utils.resolveTextNodeFromElementAndOffset(endElement, metadata.endOffset || 0);
      if (!startResolved || !endResolved) return null;

      try {
        const range = document.createRange();
        range.setStart(startResolved.node, startResolved.offset);
        range.setEnd(endResolved.node, endResolved.offset);
        return range.collapsed ? null : range;
      } catch (_) {
        return null;
      }
    },

    findRangeByTextWithContext(text, contextBefore, contextAfter) {
      if (!text) return null;

      const normalizedTarget = Utils.normalizeWhitespace(text);
      if (!normalizedTarget) return null;

      const textNodes = [];
      const starts = [];
      let combined = '';
      let cursor = 0;

      const walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT, {
        acceptNode(node) {
          const content = node.textContent || '';
          return content.trim().length === 0
            ? NodeFilter.FILTER_REJECT
            : NodeFilter.FILTER_ACCEPT;
        },
      });

      let node;
      while ((node = walker.nextNode())) {
        const chunk = Utils.normalizeWhitespace(node.textContent || '');
        if (!chunk) continue;
        textNodes.push({ node, text: chunk });
        starts.push(cursor);
        combined += chunk + ' ';
        cursor = combined.length;
      }

      const normalizedCombined = Utils.normalizeWhitespace(combined);
      let globalIndex = normalizedCombined.indexOf(normalizedTarget);
      if (globalIndex === -1) return null;

      const contextBeforeNeedle = contextBefore
        ? Utils.normalizeWhitespace(contextBefore).split(' ').slice(-3).join(' ')
        : '';
      const contextAfterNeedle = contextAfter
        ? Utils.normalizeWhitespace(contextAfter).split(' ').slice(0, 3).join(' ')
        : '';

      while (globalIndex !== -1) {
        const around = normalizedCombined.slice(
          Math.max(0, globalIndex - 160),
          Math.min(normalizedCombined.length, globalIndex + normalizedTarget.length + 160),
        );

        const beforeOk = !contextBeforeNeedle || around.includes(contextBeforeNeedle);
        const afterOk = !contextAfterNeedle || around.includes(contextAfterNeedle);

        if (beforeOk || afterOk) {
          const endGlobal = globalIndex + normalizedTarget.length;

          let startNodeIndex = 0;
          while (
            startNodeIndex < starts.length - 1 &&
            starts[startNodeIndex + 1] <= globalIndex
          ) {
            startNodeIndex += 1;
          }

          let endNodeIndex = startNodeIndex;
          while (
            endNodeIndex < starts.length - 1 &&
            starts[endNodeIndex + 1] < endGlobal
          ) {
            endNodeIndex += 1;
          }

          const startNodeData = textNodes[startNodeIndex];
          const endNodeData = textNodes[endNodeIndex];
          if (!startNodeData || !endNodeData) return null;

          const startOffset = Math.max(0, globalIndex - starts[startNodeIndex]);
          const endOffset = Math.max(0, endGlobal - starts[endNodeIndex]);

          try {
            const range = document.createRange();
            range.setStart(
              startNodeData.node,
              Math.min(startOffset, (startNodeData.node.textContent || '').length),
            );
            range.setEnd(
              endNodeData.node,
              Math.min(endOffset, (endNodeData.node.textContent || '').length),
            );
            if (!range.collapsed) return range;
          } catch (_) {}
        }

        globalIndex = normalizedCombined.indexOf(normalizedTarget, globalIndex + 1);
      }

      return null;
    },

    findRangeByFuzzyMetadata(text, metadata = null) {
      const targetText = metadata?.plainText || text;
      const targetTokens = Utils.tokenizeWords(targetText);
      if (targetTokens.length === 0) return null;

      const tokens = Utils.buildDocumentTokenIndex(document.body);
      if (tokens.length === 0) return null;

      const firstAnchor = Utils.normalizeToken(metadata?.firstWord || targetTokens[0] || '');
      const lastAnchor = Utils.normalizeToken(
        metadata?.lastWord || targetTokens[targetTokens.length - 1] || '',
      );

      const expectedWordCount = Number(
        metadata?.selectedWordCount || metadata?.wordCount || targetTokens.length,
      ) || targetTokens.length;
      const minWindow = Math.max(1, expectedWordCount - 4);
      const maxWindow = Math.max(minWindow, expectedWordCount + 4);

      const beforeTokens = Utils.tokenizeWords(metadata?.contextBefore || '').slice(-4);
      const afterTokens = Utils.tokenizeWords(metadata?.contextAfter || '').slice(0, 4);

      let best = null;

      for (let startIndex = 0; startIndex < tokens.length; startIndex += 1) {
        const startsWithAnchor = !firstAnchor || tokens[startIndex].normalized === firstAnchor;
        if (!startsWithAnchor && expectedWordCount > 2) continue;

        for (let windowSize = minWindow; windowSize <= maxWindow; windowSize += 1) {
          const endIndex = startIndex + windowSize - 1;
          if (endIndex >= tokens.length) break;

          const candidateTokens = tokens.slice(startIndex, endIndex + 1).map((entry) => entry.normalized);
          const lexicalScore = Utils.jaccardSimilarity(targetTokens, candidateTokens);
          if (lexicalScore < 0.18) continue;

          let score = lexicalScore;

          if (firstAnchor && tokens[startIndex].normalized === firstAnchor) {
            score += 0.22;
          }
          if (lastAnchor && tokens[endIndex].normalized === lastAnchor) {
            score += 0.22;
          }

          const beforeCandidate = tokens
            .slice(Math.max(0, startIndex - 4), startIndex)
            .map((entry) => entry.normalized);
          const afterCandidate = tokens
            .slice(endIndex + 1, Math.min(tokens.length, endIndex + 5))
            .map((entry) => entry.normalized);

          const beforeScore = Utils.jaccardSimilarity(beforeTokens, beforeCandidate);
          const afterScore = Utils.jaccardSimilarity(afterTokens, afterCandidate);

          if (beforeTokens.length > 0) score += beforeScore * 0.14;
          if (afterTokens.length > 0) score += afterScore * 0.14;

          const expectedChars = Number(metadata?.selectedCharLength || targetText.length || 0);
          if (expectedChars > 0) {
            const candidateRawText = tokens
              .slice(startIndex, endIndex + 1)
              .map((entry) => entry.raw)
              .join(' ');
            const diffRatio = Math.abs(candidateRawText.length - expectedChars) / expectedChars;
            score += Math.max(0, 0.12 - Math.min(0.12, diffRatio));
          }

          if (!best || score > best.score) {
            best = { startIndex, endIndex, score };
          }
        }
      }

      if (!best || best.score < 0.3) return null;
      return Utils.tokensToRange(tokens[best.startIndex], tokens[best.endIndex]);
    },

    findRangeByLooseAnchors(text, metadata = null) {
      const targetText = metadata?.plainText || text;
      const targetTokens = Utils.tokenizeWords(targetText);
      if (targetTokens.length === 0) return null;

      const tokens = Utils.buildDocumentTokenIndex(document.body);
      if (tokens.length === 0) return null;

      const firstAnchor = Utils.normalizeToken(metadata?.firstWord || targetTokens[0] || '');
      const lastAnchor = Utils.normalizeToken(
        metadata?.lastWord || targetTokens[targetTokens.length - 1] || '',
      );

      const expectedWordCount = Number(
        metadata?.selectedWordCount || metadata?.wordCount || targetTokens.length,
      ) || targetTokens.length;
      const minWindow = Math.max(1, expectedWordCount - 8);
      const maxWindow = Math.max(minWindow, expectedWordCount + 8);

      let best = null;

      for (let startIndex = 0; startIndex < tokens.length; startIndex += 1) {
        const startMatch = !firstAnchor || tokens[startIndex].normalized === firstAnchor;
        if (!startMatch && firstAnchor) continue;

        for (let windowSize = minWindow; windowSize <= maxWindow; windowSize += 1) {
          const endIndex = startIndex + windowSize - 1;
          if (endIndex >= tokens.length) break;

          const candidateTokens = tokens.slice(startIndex, endIndex + 1).map((entry) => entry.normalized);
          const overlap = Utils.jaccardSimilarity(targetTokens, candidateTokens);

          let score = overlap;
          if (firstAnchor && tokens[startIndex].normalized === firstAnchor) score += 0.2;
          if (lastAnchor && tokens[endIndex].normalized === lastAnchor) score += 0.2;

          if (!best || score > best.score) {
            best = { startIndex, endIndex, score };
          }
        }
      }

      if (!best || best.score < 0.2) return null;
      return Utils.tokensToRange(tokens[best.startIndex], tokens[best.endIndex]);
    },

    wrapRange(range, id, color, opacity) {
      try {
        const startContainer = range.startContainer;
        const endContainer = range.endContainer;
        const startOffset = range.startOffset;
        const endOffset = range.endOffset;
        const commonAncestor = range.commonAncestorContainer;

        const nodesToWrap = [];
        const walker = document.createTreeWalker(
          commonAncestor,
          NodeFilter.SHOW_TEXT,
          null,
          false
        );

        let node = walker.currentNode;
        let foundStart = false;

        while (node) {
          // Skip text inside math elements
          if (Utils.isInMathElement(node)) {
            node = walker.nextNode();
            continue;
          }

          if (node === startContainer) {
            foundStart = true;
            if (startContainer === endContainer) {
              // Same node - split and collect middle part
              if (node.nodeType === Node.TEXT_NODE && startOffset < endOffset) {
                const before = node.splitText(startOffset);
                const after = before.splitText(endOffset - startOffset);
                nodesToWrap.push(before);
              }
              break;
            } else {
              // Start of range - split and take everything after startOffset
              if (node.nodeType === Node.TEXT_NODE) {
                const after = node.splitText(startOffset);
                nodesToWrap.push(after);
              }
            }
          } else if (foundStart) {
            if (node === endContainer) {
              // End of range - split and take everything before endOffset
              if (node.nodeType === Node.TEXT_NODE && endOffset > 0) {
                node.splitText(endOffset);
                nodesToWrap.push(node);
              }
              break;
            } else {
              // Middle nodes - wrap entire node
              if (node.nodeType === Node.TEXT_NODE && node.textContent?.trim()) {
                nodesToWrap.push(node);
              }
            }
          }
          node = walker.nextNode();
        }

        if (nodesToWrap.length === 0) return null;

        // Wrap each text node in a span
        nodesToWrap.forEach((textNode) => {
          if (!textNode || !textNode.parentNode) return;

          const span = document.createElement('span');
          span.className = 'annotation-highlight';
          span.setAttribute('data-highlight-id', id);
          span.setAttribute('data-original-text', textNode.nodeValue);
          span.style.backgroundColor = Utils.withAlpha(color, opacity);
          span.style.display = 'inline';

          textNode.parentNode.insertBefore(span, textNode);
          span.appendChild(textNode);
        });

        const firstSpan = document.querySelector(`span[data-highlight-id="${id}"]`);
        if (firstSpan) {
          firstSpan.id = id;
          document.querySelectorAll(`span[data-highlight-id="${id}"]`).forEach((span) => {
            span.addEventListener('click', (event) => {
              if (!window.AnnotationBridge) return;
              const target = event.currentTarget;
              if (!target || typeof target.getBoundingClientRect !== 'function') {
                window.AnnotationBridge.postMessage(JSON.stringify({ action: 'highlight_clicked', id }));
                return;
              }
              const rect = target.getBoundingClientRect();
              window.AnnotationBridge.postMessage(
                JSON.stringify({
                  action: 'highlight_clicked',
                  id,
                  x: rect.left,
                  y: rect.top,
                  width: rect.width,
                  height: rect.height,
                }),
              );
            });
          });
          return firstSpan;
        }
        return null;
      } catch (_) {
        return null;
      }
    },

    applyHighlight(id, text, color, metadata = null, opacity = 0.35) {
      const existing = document.getElementById(id);
      if (existing) {
        existing.style.backgroundColor = Utils.withAlpha(color, opacity);
        return true;
      }

      let range = metadata ? this.createRangeFromMetadata(metadata) : null;

      if (!range) {
        range = this.getLastLiveRangeCandidate(text || metadata?.plainText);
      }

      if (!range) {
        const selection = window.getSelection();
        if (selection && selection.rangeCount > 0) {
          const selectedRange = selection.getRangeAt(0);
          if (!selectedRange.collapsed) range = selectedRange;
        }
      }

      const candidateTexts = Utils.uniqueNonEmptyStrings([
        text,
        metadata?.plainText,
        Utils.htmlToPlainText(metadata?.htmlContent),
      ]);

      if (!range) {
        for (const candidate of candidateTexts) {
          range = this.findRangeByTextWithContext(
            candidate,
            metadata?.contextBefore,
            metadata?.contextAfter,
          );
          if (range) break;
        }
      }

      if (!range) {
        for (const candidate of candidateTexts) {
          range = this.findRangeByFuzzyMetadata(candidate, metadata);
          if (range) break;
        }
      }

      if (!range) {
        for (const candidate of candidateTexts) {
          range = this.findRangeByLooseAnchors(candidate, metadata);
          if (range) break;
        }
      }

      if (!range || range.collapsed) return false;
      const selectedText = range.toString().trim();
      if (!selectedText) return false;

      const wrapped = this.wrapRange(range, id, color, opacity);
      if (!wrapped) return false;
      this.lastLiveRange = null;
      this.lastLiveText = '';

      const finalMetadata = metadata || this.buildMetadataFromRange(range, selectedText) || {};
      this.highlights.set(id, { id, text: selectedText, color, opacity, ...finalMetadata });

      if (CONFIG.clearSelectionAfterHighlight) {
        const selection = window.getSelection();
        if (selection) selection.removeAllRanges();
      }

      return true;
    },

    restoreHighlight(id, text, color, metadata = null, opacity = 0.35) {
      return this.applyHighlight(id, text, color, metadata, opacity);
    },

    removeHighlight(id) {
      const allSpans = document.querySelectorAll(`span[data-highlight-id="${id}"]`);
      if (allSpans.length === 0) return false;

      const parentsToClean = new Set();

      allSpans.forEach((span) => {
        const parent = span.parentNode;
        if (!parent) return;

        // Move all children out of the span back to parent
        while (span.firstChild) {
          parent.insertBefore(span.firstChild, span);
        }

        // Remove the now-empty span
        parent.removeChild(span);
        parentsToClean.add(parent);
      });

      // Merge adjacent text nodes in affected parents
      parentsToClean.forEach((parent) => {
        let currentNode = parent.firstChild;
        while (currentNode) {
          const nextNode = currentNode.nextSibling;

          // If current and next are both text nodes, merge them
          if (
            currentNode.nodeType === Node.TEXT_NODE &&
            nextNode &&
            nextNode.nodeType === Node.TEXT_NODE
          ) {
            currentNode.nodeValue += nextNode.nodeValue;
            parent.removeChild(nextNode);
            // Don't advance; check if next-next is also text
          } else {
            currentNode = nextNode;
          }
        }
      });

      this.highlights.delete(id);
      return true;
    },

    clearAll() {
      Array.from(this.highlights.keys()).forEach((id) => this.removeHighlight(id));
    },

    updateColor(id, color) {
      // Update all spans with this highlight id
      const allSpans = document.querySelectorAll(`span[data-highlight-id="${id}"]`);
      if (allSpans.length === 0) return false;

      const current = this.highlights.get(id);
      const opacity = current?.opacity ?? 0.35;
      const newBgColor = Utils.withAlpha(color, opacity);

      allSpans.forEach((span) => {
        span.style.backgroundColor = newBgColor;
      });

      if (current) current.color = color;
      return true;
    },

    scrollToHighlight(id) {
      console.log(`[HighlightEngine] scrollToHighlight called with id: ${id}`);
      const spans = document.querySelectorAll('span[data-highlight-id]');
      console.log(`[HighlightEngine] Found ${spans.length} highlight spans in DOM`);
      
      const firstSpan = Array.from(spans).find(
        (span) => span.getAttribute('data-highlight-id') === String(id)
      );
      
      if (!firstSpan) {
        console.log(`[HighlightEngine] Could not find span with id: ${id}`);
        return false;
      }
      
      console.log(`[HighlightEngine] Found highlight element, animating scroll`);
      
      try {
        const targetScroll = firstSpan.offsetTop - (window.innerHeight / 2);
        const currentScroll = window.scrollY || window.pageYOffset || 
                             document.documentElement.scrollTop || 
                             document.body.scrollTop || 0;
        
        console.log(`[HighlightEngine] Current scroll: ${currentScroll}, Target: ${targetScroll}`);
        
        // Smooth animation over 800ms
        const duration = 800;
        const startTime = Date.now();
        const distance = targetScroll - currentScroll;
        
        const animate = () => {
          const elapsed = Date.now() - startTime;
          const progress = Math.min(elapsed / duration, 1);
          
          // Easing function (ease-in-out)
          const easeProgress = progress < 0.5 
            ? 2 * progress * progress 
            : 1 - Math.pow(-2 * progress + 2, 2) / 2;
          
          const newScrollTop = currentScroll + (distance * easeProgress);
          
          // Set scroll on all possible containers
          window.scrollTo(0, newScrollTop);
          document.documentElement.scrollTop = newScrollTop;
          document.body.scrollTop = newScrollTop;
          
          if (progress < 1) {
            requestAnimationFrame(animate);
          }
        };
        
        requestAnimationFrame(animate);
        
        return true;
      } catch (e) {
        console.log(`[HighlightEngine] Scroll error: ${e}`);
        return false;
      }
    },

    getHighlight(id) {
      return this.highlights.get(id) || null;
    },

    getAllHighlights() {
      return Array.from(this.highlights.values());
    },
  };

  const SelectionHandler = {
    initialized: false,
    timeout: null,
    lastSelection: '',

    _captureCurrentSelection() {
      const selection = window.getSelection();
      if (!selection || selection.rangeCount === 0) return;
      const range = selection.getRangeAt(0);
      if (!range || range.collapsed) return;
      const text = selection.toString().trim();
      if (!text) return;
      HighlightEngine.setLastLiveSelection(range, text);
    },

    init() {
      if (this.initialized) return;
      document.addEventListener('selectionchange', () => {
        this._captureCurrentSelection();
        this._debounce();
      });
      document.addEventListener('mouseup', () => this._debounce());
      document.addEventListener('touchend', () => setTimeout(() => this._debounce(), 60));
      document.addEventListener('contextmenu', (e) => {
        const sel = window.getSelection();
        if (sel && sel.toString().trim()) e.preventDefault();
      });
      this.initialized = true;
    },

    _debounce() {
      if (this.timeout) clearTimeout(this.timeout);
      this.timeout = setTimeout(() => this.handleSelection(), CONFIG.debounceDelay);
    },

    handleSelection() {
      const selection = window.getSelection();
      if (!selection || selection.rangeCount === 0) return;

      const range = selection.getRangeAt(0);
      const text = selection.toString().trim();

      if (!text || range.collapsed) {
        if (this.lastSelection) {
          this.lastSelection = '';
          this._sendCleared();
        }
        return;
      }

      if (text === this.lastSelection) return;
      this.lastSelection = text;

      const rect = range.getBoundingClientRect();
      const metadata = HighlightEngine.buildMetadataFromRange(range, text) || {};
      HighlightEngine.setLastLiveSelection(range, text);

      const payload = {
        action: 'text_selected',
        text,
        x: rect.left,
        y: rect.top,
        width: rect.width,
        height: rect.height,
        hasFormula: /\\|\$|\(|\)|\[|\]/.test(text),
        ...metadata,
      };

      if (window.AnnotationBridge) {
        window.AnnotationBridge.postMessage(JSON.stringify(payload));
      }
    },

    _sendCleared() {
      if (!window.AnnotationBridge) return;
      window.AnnotationBridge.postMessage(JSON.stringify({ action: 'selection_cleared' }));
    },
  };

  const SearchEngine = {
    query: '',
    matchCount: 0,
    currentIndex: -1,

    clear() {
      const matches = document.querySelectorAll('.search-highlight');
      matches.forEach((span) => {
        const parent = span.parentNode;
        if (!parent) return;
        parent.replaceChild(document.createTextNode(span.textContent), span);
        parent.normalize();
      });

      this.query = '';
      this.matchCount = 0;
      this.currentIndex = -1;
      setTimeout(() => MathSupport.retypeset(), 0);
    },

    search(query) {
      this.clear();
      const normalized = (query || '').trim();
      if (!normalized) return { total: 0, current: 0 };

      const textNodes = [];
      const walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT, {
        acceptNode(node) {
          const parent = node.parentElement;
          if (!parent) return NodeFilter.FILTER_REJECT;
          if (parent.closest('script') || parent.closest('style') || parent.closest('noscript')) {
            return NodeFilter.FILTER_REJECT;
          }
          return (node.textContent || '').trim().length > 0
            ? NodeFilter.FILTER_ACCEPT
            : NodeFilter.FILTER_REJECT;
        },
      });

      let node;
      while ((node = walker.nextNode())) {
        textNodes.push(node);
      }

      const regex = new RegExp(Utils.escapeRegExp(normalized), 'gi');

      textNodes.forEach((textNode) => {
        const text = textNode.textContent || '';
        const matches = [];
        regex.lastIndex = 0;

        let match;
        while ((match = regex.exec(text)) !== null) {
          matches.push({ index: match.index, value: match[0] });
          if (match.index === regex.lastIndex) regex.lastIndex += 1;
        }

        if (matches.length === 0) return;

        const fragment = document.createDocumentFragment();
        let lastIndex = 0;

        matches.forEach((entry) => {
          if (entry.index > lastIndex) {
            fragment.appendChild(document.createTextNode(text.substring(lastIndex, entry.index)));
          }

          const span = document.createElement('span');
          span.className = 'search-highlight';
          span.textContent = entry.value;
          span.setAttribute('data-match-index', String(this.matchCount));
          fragment.appendChild(span);

          this.matchCount += 1;
          lastIndex = entry.index + entry.value.length;
        });

        if (lastIndex < text.length) {
          fragment.appendChild(document.createTextNode(text.substring(lastIndex)));
        }

        if (textNode.parentNode) {
          textNode.parentNode.replaceChild(fragment, textNode);
        }
      });

      this.query = normalized;
      if (this.matchCount > 0) {
        this.currentIndex = 0;
        this._focusCurrent();
      }

      setTimeout(() => MathSupport.retypeset(), 0);
      return { total: this.matchCount, current: this.matchCount > 0 ? this.currentIndex + 1 : 0 };
    },

    next() {
      if (this.matchCount === 0) return { total: 0, current: 0 };
      this.currentIndex = (this.currentIndex + 1) % this.matchCount;
      this._focusCurrent();
      return { total: this.matchCount, current: this.currentIndex + 1 };
    },

    previous() {
      if (this.matchCount === 0) return { total: 0, current: 0 };
      this.currentIndex = (this.currentIndex - 1 + this.matchCount) % this.matchCount;
      this._focusCurrent();
      return { total: this.matchCount, current: this.currentIndex + 1 };
    },

    getStatus() {
      return {
        query: this.query,
        total: this.matchCount,
        current: this.matchCount > 0 ? this.currentIndex + 1 : 0,
        hasResults: this.matchCount > 0,
      };
    },

    _focusCurrent() {
      const matches = document.querySelectorAll('.search-highlight');
      matches.forEach((el) => el.classList.remove('search-highlight-active'));
      if (this.currentIndex < 0 || this.currentIndex >= matches.length) return;
      const current = matches[this.currentIndex];
      if (!current) return;
      current.classList.add('search-highlight-active');
      
      // Use custom animation for scroll (same as highlight scroll)
      try {
        const targetScroll = current.offsetTop - (window.innerHeight / 2);
        const currentScroll = window.scrollY || window.pageYOffset || 
                             document.documentElement.scrollTop || 
                             document.body.scrollTop || 0;
        
        console.log(`[SearchEngine] Scrolling to match at ${targetScroll}, current: ${currentScroll}`);
        
        const duration = 600;
        const startTime = Date.now();
        const distance = targetScroll - currentScroll;
        
        const animate = () => {
          const elapsed = Date.now() - startTime;
          const progress = Math.min(elapsed / duration, 1);
          
          // Easing function (ease-in-out)
          const easeProgress = progress < 0.5 
            ? 2 * progress * progress 
            : 1 - Math.pow(-2 * progress + 2, 2) / 2;
          
          const newScrollTop = currentScroll + (distance * easeProgress);
          
          window.scrollTo(0, newScrollTop);
          document.documentElement.scrollTop = newScrollTop;
          document.body.scrollTop = newScrollTop;
          
          if (progress < 1) {
            requestAnimationFrame(animate);
          }
        };
        
        requestAnimationFrame(animate);
      } catch (e) {
        console.log(`[SearchEngine] Scroll error: ${e}`);
        current.scrollIntoView({ behavior: 'smooth', block: 'center', inline: 'nearest' });
      }
    },
  };

  const ReaderControls = {
    setFontScale(scale) {
      const safe = Math.max(0.8, Math.min(1.6, Number(scale) || 1));
      document.documentElement.style.setProperty('--paper-font-scale', String(safe));
      return safe;
    },
  };

  const getScrollMetrics = () => {
    const docEl = document.documentElement || document.body;
    const body = document.body || docEl;

    const scrollTop =
      window.scrollY ||
      window.pageYOffset ||
      docEl.scrollTop ||
      body.scrollTop ||
      0;

    const viewportHeight = window.innerHeight || docEl.clientHeight || body.clientHeight || 0;
    const scrollHeight = Math.max(
      docEl.scrollHeight || 0,
      body.scrollHeight || 0,
      docEl.offsetHeight || 0,
      body.offsetHeight || 0,
      docEl.clientHeight || 0,
      body.clientHeight || 0,
    );

    const total = Math.max(0, scrollHeight - viewportHeight);
    const progress = total <= 0 ? 0 : Math.min(1, Math.max(0, scrollTop / total));

    return { scrollTop, total, progress };
  };

  const emitScrollProgress = () => {
    if (!window.AnnotationBridge) return;
    const { progress } = getScrollMetrics();
    window.AnnotationBridge.postMessage(JSON.stringify({ action: 'scroll_progress', progress }));
  };

  let scrollTicking = false;
  window.addEventListener('scroll', () => {
    if (scrollTicking) return;
    scrollTicking = true;
    window.requestAnimationFrame(() => {
      emitScrollProgress();
      scrollTicking = false;
    });
  }, { passive: true });

  document.addEventListener('scroll', () => {
    if (scrollTicking) return;
    scrollTicking = true;
    window.requestAnimationFrame(() => {
      emitScrollProgress();
      scrollTicking = false;
    });
  }, { passive: true, capture: true });

  window.AnnotationEngine = {
    init(themeColors = null) {
      if (themeColors) {
        THEME_COLORS = { ...THEME_COLORS, ...themeColors };
      }
      MathSupport.init();
      SelectionHandler.init();
      emitScrollProgress();
      setTimeout(() => MathSupport.retypeset(), 100);
      return true;
    },

    applyHighlight(id, text, color, metadata = null) {
      return HighlightEngine.applyHighlight(id, text, color, metadata, 0.35);
    },

    restoreHighlight(id, text, color, metadata = null) {
      return HighlightEngine.restoreHighlight(id, text, color, metadata, 0.35);
    },

    removeHighlight: (id) => HighlightEngine.removeHighlight(id),
    updateColor: (id, color) => HighlightEngine.updateColor(id, color),
    clearAll: () => HighlightEngine.clearAll(),
    scrollToHighlight: (id) => HighlightEngine.scrollToHighlight(id),
    getHighlightCount: () => HighlightEngine.highlights.size,
    getHighlights: () => HighlightEngine.getAllHighlights(),
    getHighlight: (id) => HighlightEngine.getHighlight(id),

    searchText: (query) => SearchEngine.search(query),
    searchNext: () => SearchEngine.next(),
    searchPrevious: () => SearchEngine.previous(),
    clearSearch: () => SearchEngine.clear(),
    getSearchStatus: () => SearchEngine.getStatus(),

    setFontScale: (scale) => ReaderControls.setFontScale(scale),
    retypesetMath: (element = null) => MathSupport.retypeset(element),
    setThemeColors: (colors) => {
      THEME_COLORS = { ...THEME_COLORS, ...colors };
      return THEME_COLORS;
    },
    getThemeColors: () => THEME_COLORS,
  };

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => window.AnnotationEngine.init());
  } else {
    window.AnnotationEngine.init();
  }
})();
