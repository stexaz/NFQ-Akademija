<?php
/**
 * Created by Andrius Petrauskis (stexaz@gmail.com).
 * User: andrius
 * Date: 10/25/13
 * Time: 10:54 PM
 * Copyright 2013
 */

class LoginController extends BaseController {



    public function loginGet()
    {
        $this->layout = View::make('login');
    }

    public function loginPost()
    {
        $login = Auth::attempt( array('username' => Input::get('username'), 'password' => Input::get('password')) );
        if ($login) {
            return Redirect::to('/');
        }
        $this->layout = View::make('login', array('message'=>'Invalid username or password'));
    }
}