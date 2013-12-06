<?php
/**
 * Created by Andrius Petrauskis (stexaz@gmail.com).
 * User: andrius
 * Date: 10/25/13
 * Time: 10:54 PM
 * Copyright 2013
 */

class PhotoController extends BaseController {



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

    public function postUpload(){

        $input = Input::all();
        $rules = array(
            'file' => 'image|max:3000',
        );

        $validation = Validator::make($input, $rules);

        if ($validation->fails())
        {
            return Response::make($validation->errors->first(), 400);
        }

        $file = Input::file('file');

        $extension = File::extension($file['name']);
        $directory = path('public').'uploads/'.sha1(time());
        $filename = sha1(time().time()).".{$extension}";

        $upload_success = Input::upload('file', $directory, $filename);

        if( $upload_success ) {
            return Response::json('success', 200);
        } else {
            return Response::json('error', 400);
        }
    }
}