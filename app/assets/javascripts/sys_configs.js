// Use turbolinks so click on homepage while on homepage doesnt break jquery
$(document).on('turbolinks:load', function () {
    var configList = $('.side-nav.left');
    var $configSelect = $('#config-select');
    var $currentConfig = $('#current-config');
    var addedToContainerClass = 'added-to-container';
    var notInContainerClass = 'not-in-container';
    var $username = $('#username');

    function getCurrentConfig() {
        var currentConfigId = $currentConfig.data('config-id');
        return currentConfigId
    };

    $('#config-select').on('change', function () {
        var configId = $(this).val();
        $currentConfig.data('config-id', configId);
        $('#deploy').attr('href', '/system_configs/'+configId+'/deploy');
        repopulateLeftNav()
    });

    function repopulateLeftNav() {
        var configId = $currentConfig.data('config-id');
        $.ajax({
            method: 'GET',
            url: '/system_configs/' + configId
        }).done(function (response) {
            var apps = response.apps;
            var config = response.config;
            $('#current-config').text(config.name);
            $(configList.selector + ' .app-menu-item').remove();
            $('.added-to-container').removeClass('added-to-container');
            apps.forEach(function (item) {
                addItemUIChanges(item.app.id, item.html);
            })
        })
    }

    $('body').on('click', '.add-to-app-button', function () {
        if ($username.data('uid') == '' || $username.data('uid') == undefined) {
            openLoginModal();
        } else {
            var $clicked = $(this).closest('.app-container');
            if ($clicked.hasClass('added-to-container')) {
                removeApp($clicked);
            } else {
                addApp($clicked);
            }
        }
    });

    $(configList.selector).on('click', '.remove-button', function (e) {
        e.preventDefault();
        removeApp($(this))
    });

    function openLoginModal(){
        var options = {};
        var modal = $('[data-remodal-id=login-modal]').remodal(options);
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
        });
        modal.open();
    }

    function removeApp($clickedItem) {
        var appId = $clickedItem.data('app-id');
        $.ajax({
            method: 'PUT',
            url: '/system_configs/' + getCurrentConfig(),
            data: {app_id: appId, config_action: 'remove'},
            dataType: 'json'
        }).done(function (response) {
            removeItemUIChanges(appId);
        }).fail(function (response) {
            debugger
        })
    }

    function removeItemUIChanges(appId) {
        var appList = $('.app-list');
        var menuItem = configList.find('[data-app-id=' + appId + ']');
        var listItem = appList.find('[data-app-id=' + appId + ']');

        menuItem.remove();
        listItem.removeClass(addedToContainerClass);
        listItem.addClass(notInContainerClass);
        $('.flash .content').html('<b>App removed from configuration</b>')
        $('.flash').addClass('flash-warn');
        $('.flash').slideDown(1000);
        setTimeout(function () {
            $('.flash').slideUp(800);
        }, 3000)

    }

    function addApp($clickedItem) {
        var appId = $clickedItem.data('app-id');
        $.ajax({
            method: 'PUT',
            url: '/system_configs/' + getCurrentConfig(),
            data: {app_id: appId, config_action: 'add'},
            dataType: 'json'
        }).done(function (response) {
            addItemUIChanges(appId, response.html);
        }).fail(function (response) {
            console.log(response)
        })
    }

    function addItemUIChanges(appId, html) {
        var appList = $('.app-list');
        var listItem = appList.find('[data-app-id=' + appId + ']');

        configList.append(html);
        listItem.removeClass(notInContainerClass);
        listItem.addClass(addedToContainerClass);
        $('.flash').removeClass('flash-warn');
        $('.flash .content').html('<b>App added to configuration</b>')

        $('.flash').slideDown(1000);
        setTimeout(function () {
            $('.flash').slideUp(800);
        }, 3000)
    }

    $('#search-field').on('keyup', function () {
        var $input = $(this);
        var val = $input.val();
        if (val.length >= 3 || val.length <= 0 || val == undefined) {
            $.ajax({
                url: '/apps/search',
                method: 'GET',
                data: {query: val, config_id: getCurrentConfig()}
            }).done(function (response) {
                $('.app-list').replaceWith(response)
            }).fail(function () {
                console.log('Oops', e)
            })
        }
    })

    //function makeAppAndSend(){
    //    $('#deploy').on('click',function(){
    //        $.ajax({
    //            method: 'GET',
    //            url: '/system_configs/'+ getCurrentConfig() +'/deploy',
    //        }).done(function(response){
    //
    //        })
    //    })
    //};

});
