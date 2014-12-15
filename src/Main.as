package {

import animales.Game;

import flash.desktop.NativeApplication;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.media.AudioPlaybackMode;
import flash.media.SoundMixer;
import flash.media.SoundTransform;

import starling.core.Starling;
import starling.utils.HAlign;
import starling.utils.VAlign;

[SWF(frameRate="48", backgroundColor="#ffffff")]
public class Main extends Sprite {
    private const WIDTH:int = 1024 * 2;
    private const VOLUME_1:SoundTransform = new SoundTransform(1);
    private const VOLUME_0:SoundTransform = new SoundTransform(0);
    public static var instance:Main;
    public function Main() {
        addEventListener(Event.ADDED_TO_STAGE, initialize);
        NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate);
        NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate);
        SoundMixer.audioPlaybackMode = AudioPlaybackMode.AMBIENT;
        instance = this;
    }

    private function handleDeactivate(event:Event):void {
        Starling.current.stop(true);
        SoundMixer.soundTransform = VOLUME_0;
    }

    private function handleActivate(event:Event):void {
        Starling.current.start();
        SoundMixer.soundTransform = VOLUME_1;
    }

    private function initialize(event:Event):void {
        var star:Starling = new Starling(Game, stage, new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), null, 'auto', 'auto');
        star.start();
        star.stage.stageWidth = WIDTH;
        star.stage.stageHeight = stage.fullScreenHeight / stage.fullScreenWidth * WIDTH;
        star.showStatsAt(HAlign.LEFT,VAlign.TOP,2);
    }
}
}
