devconfig = require 'devconfig'
config = require 'config'
mediator = require 'mediator'

remove = (orginal, toRemove) ->
  regex = "(^|\\b)#{toRemove.split(' ').join('|')}(\\b|$)"
  orginal.replace(new RegExp(regex, 'gi'), ' ')

addClass = (el, className) ->
  if el.classList and not el.classList.contains(className)
    el.classList.add(className)
  else if el.className.indexOf(className) is -1
    el.className += " #{className}"

removeClass = (el, className) ->
  if el.classList and el.classList.contains(className)
    el.classList.remove className
  else if el.className.indexOf(className) is -1
    el.className = remove el.className, className

replaceClass = (el, oldClassName, newClassName) ->
  removeClass el, oldClassName
  addClass el, newClassName

# Application-specific utilities
# ------------------------------

# Delegate to Chaplin’s utils module.
utils = Chaplin.utils.beget Chaplin.utils

_.extend utils,
  addClass: addClass
  removeClass: removeClass
  replaceClass: replaceClass
  log: console.log

  hasClass: (el, className) ->
    if el.classList
      el.classList.contains(className)
    else
      el.className is className

  addMeta: (head, key, value, keyType='name') ->
    meta = document.createElement 'meta'
    meta.setAttribute keyType, key
    meta.setAttribute 'content', value
    head.appendChild meta

  updateMeta: (key, value, keyType='name') ->
    if keyType is 'name'
      meta = document.getElementsByName(key)[0]
    else if keyType is 'property'
      _.forEach document.getElementsByTagName('meta'), (el) ->
        if el?.attributes?.property?.value?.includes key
          meta = el

    meta?.setAttribute 'content', value

  capitalize: (text) -> "#{text[0].toUpperCase()}#{text.substring 1}"
  getRandomIndex: (items) -> Math.floor(Math.random() * items.length)

  isVisible: (name, isClass) ->
    if isClass
      el = document.getElementsByClassName(name)[0]
      el?.classList?.contains name
    else
      Boolean(document.getElementById(name)?.id)

# Prevent creating new properties and stuff.
Object.seal? utils
module.exports = utils
