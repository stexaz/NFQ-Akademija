<?php
/**
 * Created by Andrius Petrauskis.
 * Date: 10/1/13
 */

require_once 'Upload.php';
require_once 'Display.php';

$upload = new Upload;
$display = new Display;

$display->image = '';

if ($upload->isUploading()) {
$display->message = 'Norite įkelti kitą paveikslėlį?';

    if ($upload->done()) $display->image = <<<IMG
<div class="img">
    <img src="" alt="*"/>
</div>
IMG;

} else {
$display->message = 'Pasirinkite paveikslėlį';
}

$display->file_types = implode(', ', array('jpg', 'png', 'gif'));
$display->max_size = ini_get('upload_max_filesize').'b';

$display->render('upload_form.phtml');