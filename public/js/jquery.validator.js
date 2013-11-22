(function($){

    function bind(fn,obj) {
        return function() {
            fn.apply(obj,arguments);
        };
    }

    function ValidateUser() {};

    ValidateUser.prototype._create = function()
    {
        this._on(this.element,{
            "change": "onChange"
        });
    };

    ValidateUser.prototype.onChange = function(event) {
        this.checkUser();
    };

    ValidateUser.prototype.checkUser = function()
    {
        this.element.removeClass('invalid');
        $.post('/user_check', {username: this.element.val()}, bind(this._handleResponse, this),'json');
    };

    ValidateUser.prototype._handleResponse = function(data)
    {
        if (data.status == 'registered') {
            this.element.addClass('invalid');
        }
    };

    $.widget('validateUser', ValidateUser.prototype);

})(jQuery);