# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("#next").on("ajax:success", (event) ->
    [data, xhr, response] = event.detail
    $("#next").html $("#success")
  )