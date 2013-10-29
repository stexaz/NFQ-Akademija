<?php
/**
 * Created by Andrius Petrauskis (stexaz@gmail.com).
 * User: andrius
 * Date: 10/25/13
 * Time: 10:54 PM
 * Copyright 2013
 */

class IndexController extends BaseController {

    public function notLoggedIn()
    {
        $this->layout = View::make('index', array('albums' => Album::ListAll(), 'logged'=>false));
    }

    public function loggedIn()
    {
        $this->layout = View::make('index', array('albums' => Album::ListAll(), 'logged'=>true));
    }
}