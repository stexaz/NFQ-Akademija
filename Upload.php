<?php
/**
 * Created by Andrius Petrauskis.
 * Date: 10/1/13
 */

class Upload {

    private $_error = null;
    private $_name = null;
    private $_img = null;
    const FOLDER = 'uploads/';

    function isUploading($name = null)
    {
        $this->_name = $name?:current(array_keys($_FILES));
        return $name?isset($_FILES[$name]):count($_FILES)>0;
    }

    public function done()
    {
        if (!file_exists(self::FOLDER)) mkdir(self::FOLDER);
        return !$this->error() && $this->isUploaded() && $this->isImage();
    }

    public function error()
    {
        if ($this->_error !== null) return $this->_error;
        if ($_FILES[$this->_name]['error']) return $this->_error = $this->codeToMessage($_FILES[$this->_name]['error']);
        return null;
    }

    private function codeToMessage($code)
    {
        switch ($code) {
            case UPLOAD_ERR_INI_SIZE:
                $message = "Failo dydis viršytas";
                break;
            case UPLOAD_ERR_FORM_SIZE:
                $message = "Failo dydis viršytas";
                break;
            case UPLOAD_ERR_PARTIAL:
                $message = "Failas nebuvo pilnai įkeltas";
                break;
            case UPLOAD_ERR_NO_FILE:
                $message = "Pasirinkite failą!";
                break;
            case UPLOAD_ERR_NO_TMP_DIR:
                $message = "Nerasta laikina direktorija";
                break;
            case UPLOAD_ERR_CANT_WRITE:
                $message = "Nepavyko išsaugoti failo";
                break;
            case UPLOAD_ERR_EXTENSION:
                $message = "Blogas failo tipas";
                break;

            default:
                $message = "Įkelti nepavyko. Bandykite dar kartą";
                break;
        }
        return $message;
    }

    private function isUploaded()
    {
        $this->_img = md5(microtime());
        return move_uploaded_file($_FILES[$this->_name]['tmp_name'], self::FOLDER.$this->_img.'.img');
    }

    private function isImage()
    {
        if (extension_loaded('gd')){
            $im = Image::isImage(self::FOLDER.$this->_img.'.img');
            if (!$im) {
                $this->_error = 'Neleistinas paveikslėlio formatas';
                return false;
            }
            return true;
        }
        return true;
    }

    public function getUri()
    {
        return self::FOLDER.$this->_img.'.img';
    }
}