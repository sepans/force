_     = require 'underscore'
Order = require '../../models/order.coffee'

fetchPendingOrder = (req, res, options) ->
  new Order().fetchPendingOrder _.extend(
    error: -> res.redirect '/'
    session_id: req.session?.id
    accessToken: req.user?.get('accessToken')
  , options)

@shipping = (req, res) ->
  fetchPendingOrder req, res,
    success: (order) ->
      res.locals.sd.ORDER = order.toJSON()
      res.render 'templates/shipping', { order: order }

@checkout = (req, res) ->
  fetchPendingOrder req, res,
    success: (order) ->
      unless order.get('shipping_address')
        return res.redirect('/order')
      res.locals.sd.ORDER = order.toJSON()
      res.render 'templates/checkout', { order: order }

@complete = (req, res) ->
  fetchPendingOrder req, res,
    success: (order) ->
      res.locals.sd.ORDER = order.toJSON()
      res.render 'templates/complete', { order: order }

@resume = (req, res) ->
  unless (token = req.query.token) and (orderId = req.params.id)
    return res.redirect '/'

  order = new Order
    id: orderId
    token: token

  order.resume
    session_id: req.session?.id
    accessToken: req.user?.get('accessToken')
    success: -> res.redirect '/order'
    error: -> res.redirect '/'
