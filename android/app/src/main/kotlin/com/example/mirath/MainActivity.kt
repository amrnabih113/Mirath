package com.example.mirath

import android.view.ActionMode
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
	override fun onWindowStartingActionMode(callback: ActionMode.Callback?): ActionMode? {
		return null
	}

	override fun onWindowStartingActionMode(
		callback: ActionMode.Callback?,
		type: Int,
	): ActionMode? {
		return null
	}

	override fun onActionModeStarted(mode: ActionMode?) {
		mode?.finish()
		super.onActionModeStarted(mode)
	}
}
