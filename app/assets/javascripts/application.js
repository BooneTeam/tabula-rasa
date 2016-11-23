// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
// require primer
//
//= require jquery
//= require jquery_ujs
//= require remodal
//= require sys_configs
//= require turbolinks
//= require_tree .
// Use turbolinks so click on homepage while on homepage doesnt break jquery
$(document).on('turbolinks:load', function() {

    $(document).on('confirmation', ".new-config-form-remodal", function () {
        var form = $('form',$(this));
        var formData = form.serialize();
        $.ajax({
            method: 'POST',
            url: '/system_configs',
            data: formData
        }).done(function(response){
            var config = response.config;
            $('#config-select').append("<option value="+ config.id + ">" + config.name +"</option>")
            $(form).trigger('reset')
        }).fail(function(error){

        });
    });

    $('body').on('click','.remodal .login-button',function(e){
        e.preventDefault()
        $.ajax({
            url:'basic_users/sign_in',
            method:'GET',
        }).done(function(response){
            var responseWithId = "<div id='user-action-form-container'>"+ response +"</div>"
            $('#user-action-form-container').replaceWith(responseWithId);
            //$('.remodal #user-action-form-container').replaceWith(response);
            //$('#user-action-form-container').replaceWith(response);
            //$('.remodal .login-button').hide()
        }).fail(function(e){
            console.log(e)
        })
    });

    $('body').on('click','.remodal .forgot-password-button',function(e){
        e.preventDefault();
        $.ajax({
            url:'basic_users/password/new',
            method:'GET',
        }).done(function(response){
            //$('.remodal form').replaceWith(response);
            var responseWithId = "<div id='user-action-form-container'>"+ response +"</div>"
            $('#user-action-form-container').replaceWith(responseWithId);
            //$('.remodal .forgot-password-button').hide()
        }).fail(function(e){
            console.log(e)
        })
    });

    //function HideDeviseShared(){
        //$('.sign-up-button,.login-button,.forgot-password-button', '.remodal').hide();
    //}

    $('body').on('click', '.remodal .sign-up-button', function(e){
        e.preventDefault();
        $.ajax({
            url:'basic_users/sign_up',
            method:'GET',
        }).done(function(response){
            var responseWithId = "<div id='user-action-form-container'>"+ response +"</div>"
            $('#user-action-form-container').replaceWith(responseWithId);
        }).fail(function(e){
            console.log(e)
        })
    });

});