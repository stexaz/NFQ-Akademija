<?php
/**
 * Created by Andrius Petrauskis.
 * User: Andrius
 * Date: 13.10.3
 */

class Image {
    public static function formats($mime=false)
    {
        $info = gd_info();
        $r = array();
        foreach ($info as $k=>$v) {
            if ($v) {
                if(preg_match('/([A-Z]{3,4})( Read)? Support/', $k, $m)) {
                    $r[] = ($mime?'image/':'').$m[1];
                }
            }
        }

        return $r;
    }

    public static function isImage($name)
    {
        if (extension_loaded('gd')){
            $im = @imagecreatefromstring(file_get_contents($name));
            if (!$im) {
                return false;
            }
            return true;
        }
        return true;
    }
}