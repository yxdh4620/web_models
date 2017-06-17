###
# Copyright(c) 2013 Madhusudhan Srinivasa <madhums8@gmail.com>
# MIT Licensed
###
_ = require 'underscore'
path = require 'path'
fs = require 'fs'
p = require "commander"
express = require 'express'
bodyParser = require 'body-parser'
methodOverride = require 'method-override'
debuglog = require("debug")("admin-template::server")


pkg = JSON.parse(fs.readFileSync(path.join(__dirname, "../package.json")))
p.version(pkg.version)
 .option('-e, --environment [type]', 'runtime environment of [development, production, testing]', 'development')
 .parse(process.argv)

p.root = path.resolve __dirname, "../"

public_path = path.join p.root, "/public"

files = fs.readdirSync public_path

#console.dir files

html_files = []
htmls = ""
files.map (file, index) ->
  debuglog "index: #{index} file: #{file}"
  stat = fs.statSync(path.join(public_path, file))
  if stat.isFile() and path.extname(file) is '.html'
    html_files.push "/#{file}"
    htmls += "<a href='/#{file}' target='_blank'> #{path.basename(file,'.html')} </a><br/>"

console.dir html_files

app = express()
app.use(express.static(path.join(p.root, "/public"),{maxAge:864000000}))
app.set 'views', path.join(p.root, '/views')
app.set 'view engine', 'pug'
app.set 'view options', {pretty:false}
#app.use cookieParser(p.COOKIE_SECRET||'')
app.use(bodyParser({limit: '50mb'}))
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())
app.use methodOverride()

app.get "/", (req, res) -> res.send htmls

port = 3130
app.listen(port)
console.log  "***itunes-img-fetcher start on port:#{port} ***"



