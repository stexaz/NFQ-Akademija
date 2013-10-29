<?php

Route::get('/', array('before' => 'auth' ,function()
{
    return 'Hello, '.Auth::user()->email.'!';
}));

Route::get('/', 'IndexController@notLoggedIn');


Route::get('/login', 'LoginController@loginGet');

Route::post('/login', 'LoginController@loginPost');

