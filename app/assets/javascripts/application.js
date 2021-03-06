// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require turbolinks
//= require materialize-sprockets
//= require cocoon
//= require skim
//= require_tree ./shared
//= require comments
//= require vote
//= require question
//= require_tree ./channels
//= require_tree ./widgets


$(document).on('turbolinks:load', function () {
    $(".dropdown-button").dropdown();
    $(".button-collapse").sideNav();
    $('.materialize-textarea').trigger('autoresize');
    Materialize.updateTextFields();

    $('.tooltipped').tooltip({delay: 50});

});

alertFunc = function (message, color) {
    Materialize.toast(message, 4000, color);
};
