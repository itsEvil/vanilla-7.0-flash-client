package com.company.assembleegameclient.sound
{
import com.company.assembleegameclient.parameters.Parameters;

public class Music
{
    public static const MENU_MUSIC:String = "waterfall";
    public static const DEATH_MUSIC:String = "good_night";

    private static var musicName_:String = "";

    private static var song:Song = null;


    public function Music()
    {
        super();
    }

    public static function load(name:String):void {
        if (musicName_ == name) {
            return;
        }
        musicName_ = name;

        if (Parameters.data_.playMusic) {
            transitionNewMusic();
        }
    }

    private static function transitionNewMusic():void {
        if (song) {
            song.stop();
        }
        if (musicName_ == null || musicName_ == "") {
            return;
        }
        song = new Song(musicName_);
        song.play();
    }

    public static function setPlayMusic(play:Boolean):void {
        Parameters.data_.playMusic = play;
        Parameters.save();
        if (play) {
            transitionNewMusic();
        }
        else if (song) {
            song.stop(true);
            song = null;
        }
    }
}
}
