React = require "react-atom-fork"

#util = require "util"
debug = require("debug")("boot")
{div} = React.DOM

remote = require('remote')
Menu = remote.require('menu')
MenuItem = remote.require('menu-item')

Panel = require "./react/panel"
Example = require "./react/contactform"

Main = React.createClass
  render: ->
    <div>
      <Panel headerText="Panel 1" width="256px" height="256px"/>
      <Panel headerText="Panel 2" width="256px" height="256px"/>
      <Example company="FakeCo"/>
    </div>


el = document.getElementById "react"
component = React.renderComponent Main(), el

# React.renderComponent <Example company="FakeCo"/>, el

onresizeend = ->
  component.forceUpdate()

resizeTimeOut = undefined
window.onresize = ->
  clearTimeout resizeTimeOut
  resizeTimeOut = setTimeout onresizeend, 100


onQuit = ->
  remote.require("app").quit()

menu = new Menu()
menu.append new MenuItem({ label: 'Quit', click: onQuit })


oncontextmenu = (e) ->
  e.preventDefault()
  menu.popup(remote.getCurrentWindow());

window.addEventListener 'contextmenu', oncontextmenu, false
