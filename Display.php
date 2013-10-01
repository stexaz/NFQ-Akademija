<?php
/**
 * Created by Andrius Petrauskis.
 * Date: 10/1/13
 */

class Display {

    private $_vars = array();

    public function __get($param)
    {
        return isset($this->_vars[$param])?$this->_vars[$param]:null;
    }

    public function __set($param, $value)
    {
        $this->_vars[$param] = $value;
        return $value;
    }

    public function render($tpl = null, $output = true)
    {
        if ($tpl) {
           $data = file_get_contents($tpl);
           if ($data)
           {
               if (preg_match_all('/\{\$(\w*)\}/', $data, $matches)) {
                   foreach ($matches[1] as $key=>$variable)
                   {
                       if (isset($this->_vars[$variable])) $data = str_replace($matches[0][$key], $this->_vars[$variable], $data);
                   }
               }
               if (!$output) return $data;
               echo $data;
           }
        }
    }
}