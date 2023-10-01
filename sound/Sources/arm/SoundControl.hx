package arm;

import iron.object.SpeakerObject;
import iron.system.Input;

class SoundControl extends iron.Trait {

	public function new() {
		super();
		notifyOnInit(() -> {
			final mouse = Input.getMouse();
			final keyboard = Input.getKeyboard();
			final speaker = iron.Scene.active.getSpeaker('Speaker');
			trace(speaker.data);
			notifyOnUpdate( () -> {
				if(keyboard.started('a')) {
					trace('Toggle speaker (${!speaker.paused})');
					speaker.paused ? speaker.play() : speaker.pause();
				} 
				if(keyboard.started('space')) {
					// Randomly play one of the three hit sounds
					final sound = 'hit${Std.random(3)}.wav';
					trace('Play $sound');
					iron.data.Data.getSound(sound, (s:kha.Sound) -> {
						var channel = iron.system.Audio.play(s);
						channel.volume = 0.4;
					});
				}
			});
		});
	}
}
