_ = require 'underscore'
cheerio = require 'cheerio'
path = require 'path'
jade = require 'jade'
fs = require 'fs'
moment = require 'moment'
Articles = require '../../../collections/articles'
Vertical = require '../../../models/vertical'
fixtures = require '../../../test/helpers/fixtures'

render = (templateName) ->
  filename = path.resolve __dirname, "../templates/#{templateName}.jade"
  jade.compile(
    fs.readFileSync(filename),
    { filename: filename }
  )

describe 'article figure template', ->

  it 'uses the article url', ->
    html = render('feed')
      articles: new Articles([_.extend(fixtures.article, slug: 'foobar')]).models
      crop: (url) -> url
      moment: moment
      sd: {}
    html.should.containEql '/article/foobar'

describe 'vertical template', ->

  it 'renders the vertical title', ->
    html = render('vertical')
      articles: new Articles([_.extend(fixtures.article, slug: 'foobar')])
      crop: (url) -> url
      moment: moment
      sd: {}
      asset: ->
      vertical: new Vertical _.extend _.clone(fixtures.vertical), title: 'Moo Bar'
    html.should.containEql 'Moo Bar'
