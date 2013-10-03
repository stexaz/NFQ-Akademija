<?php
/**
 * Created by Andrius Petrauskis.
 * Date: 10/1/13
 */

function __autoload($name)
{
    if (file_exists($name.'.php')) include $name.'.php';
}

$upload = new Upload;
$display = new Display;

$display->image = '';
$display->message_type = 'ok';

if ($upload->isUploading()) {
$display->message = 'Norite įkelti kitą paveikslėlį?';
    if ($upload->done()) {
        $url = $upload->getUri();
        $display->image = <<<IMG
<div class="img">
    <img src="$url" alt="*"/>
</div>
IMG;
    }
    if ($upload->error()) {
        $display->message = $upload->error();
        $display->message_type = 'error';
    }
} else {
$display->message = 'Pasirinkite paveikslėlį';
}

$display->file_types = implode(', ', Image::formats());
$display->accept = implode(',', Image::formats(true));
$display->max_size = ini_get('upload_max_filesize').'b';

$display->render('upload_form.phtml');
