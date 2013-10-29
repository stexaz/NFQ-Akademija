<?php
/**
 * Created by Andrius Petrauskis (stexaz@gmail.com).
 * User: andrius
 * Date: 10/25/13
 * Time: 10:54 PM
 * Copyright 2013
 */

class LoginController extends BaseController {



    public function album()
    {

        $this->layout = View::make('album');
    }

    public function add()
    {
        $album = new Album;
        $album->title = Input::get('title');
        $album->save();
        $this->layout = View::make('index', array('message' => 'Album created'));
    }
}