package;

import lime.Assets;
import lime.media.AudioBuffer;
import lime.media.AudioSource;

/**
 * ...
 * @author Matthias Faust
 */
class Sound {
	static var LIMIT_PER_SOUND:Int = 3;
	static var _playing:Array<AudioSource> = [];
	
	public static var MUS_CHOOSER:AudioBuffer;
	public static var MUS_INTRO_DOS:AudioBuffer;
	
	public static var SND_CHARLIE_STEP:AudioBuffer;
	public static var SND_TUNNEL_STEP:AudioBuffer;
	public static var SND_ROBOT_STEP:AudioBuffer;
	
	public static var SND_DISSOLVE_WALL:AudioBuffer;
	
	public static var SND_PICKUP_MISC:AudioBuffer;
	public static var SND_PICKUP_KEY:AudioBuffer;
	public static var SND_PICKUP_GOLD:AudioBuffer;
	
	public static var SND_OPEN_DOOR:AudioBuffer;
	
	public static var SND_EXPLOSION_CHARLIE:AudioBuffer;
	public static var SND_EXPLOSION_ROBOT:AudioBuffer;
	
	public static function init() {
		MUS_CHOOSER = Assets.getAudioBuffer("assets/mus/chooser.ogg");
		MUS_INTRO_DOS = Assets.getAudioBuffer("assets/mus/intro-dos.ogg");
		
		SND_CHARLIE_STEP = Assets.getAudioBuffer("assets/sfx/step-charlie.wav");
		SND_TUNNEL_STEP = Assets.getAudioBuffer("assets/sfx/step-tunnel.wav");
		SND_ROBOT_STEP = Assets.getAudioBuffer("assets/sfx/step-robot.wav");
		
		SND_DISSOLVE_WALL = Assets.getAudioBuffer("assets/sfx/dissolve-wall.wav");
		
		SND_PICKUP_MISC = Assets.getAudioBuffer("assets/sfx/pickup-misc.wav");
		SND_PICKUP_KEY = Assets.getAudioBuffer("assets/sfx/pickup-key.wav");
		SND_PICKUP_GOLD = Assets.getAudioBuffer("assets/sfx/pickup-gold.wav");
		
		SND_OPEN_DOOR = Assets.getAudioBuffer("assets/sfx/open-door.wav");
		
		SND_EXPLOSION_CHARLIE = Assets.getAudioBuffer("assets/sfx/explosion.wav");
		SND_EXPLOSION_ROBOT = Assets.getAudioBuffer("assets/sfx/explosion-short.wav");
	}
	
	private static function findPlaying(sound:AudioBuffer):Array <AudioSource> {
		return _playing.filter(function(f:AudioSource) {
			return f.buffer == sound;
		});
	}
	public static function stop(sound:AudioBuffer) {
		var list = findPlaying(sound);
		
		if (list.length > 0) {
			for (s in list) {
				s.stop();
				s.dispose();
				_playing.remove(s);
			}
		}
	}
	
	public static function play(sound:AudioBuffer, ?repeat:Bool = false) {
		var list = findPlaying(sound);
		if (list.length >= LIMIT_PER_SOUND) return;
		
		var snd:AudioSource = new AudioSource(sound);
		_playing.push(snd);
		
		if (repeat) {
			snd.onComplete.add(function() {_playing.remove(snd); play(sound, true); });
		} else {
			snd.onComplete.add(function() {_playing.remove(snd); });
		}
		
		snd.play();
	}
	
}