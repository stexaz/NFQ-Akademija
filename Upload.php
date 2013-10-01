<?php
/**
 * Created by Andrius Petrauskis.
 * Date: 10/1/13
 */

class Upload {

    private $_error = null;
    private $_name = null;
    private $_img = null;

    function isUploading($name = null)
    {
        $this->_name = $name?:current(array_keys($_FILES));
        return $name?isset($_FILES[$name]):count($_FILES)>0;
    }

    public function done()
    {

        return !$this->error() && $this->isUploaded() && $this->isImage();
    }

    public function error()
    {
        if ($this->_error !== null) return $this->_error;
        if ($_FILES[$this->_name]['error']) return $this->_error = $_FILES[$this->_name]['error'];
        return null;
    }

    private function isUploaded()
    {
        $this->_img = md5(microtime());
        setcookie('image', $this->_img);
        return move_uploaded_file($_FILES[$this->_name]['tmp_name'], 'uploads/'.$this->_img.'.img');
    }

    private function isImage()
    {
        if (extension_loaded('gd')){
            $im = @imagecreatefromstring(file_get_contents('uploads/'.$this->_img.'.img'));
            if (!$im) {
                $this->_error = 'Invalid file type';
                return false;
            }
            return true;
        }
        return true;
    }
}