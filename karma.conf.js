var basePath = '' // base path used to resolve files and exclude
  , files =  // list of files / patterns to load in the browsers
    [ JASMINE
    , JASMINE_ADAPTER
    , 'given.js'
    , 'tests/*.coffee'
    ]
  , exclude = // list of files to exclude
    []
  , reporters = // test results reporter to use: 'dots', 'progress', 'junit'
    ['progress']
  , port = 9876 // web server port
  , runnerPort = 9100 // cli runner port
  , colors = true // reporters and logs
  , logLevel = LOG_INFO // LOG_DISABLE, LOG_ERROR, LOG_WARN, LOG_INFO, LOG_DEBUG
  , autoWatch = true // watch files and execute tests whenever any file changes
  , browsers = // Mac: PhantomJS, Chrome, ChromeCanary, Firefox, Opera, Safari
    ['PhantomJS']
  , captureTimeout = 60e3 // kill browser in if it's still not captured in 1 min
  , singleRun = false // true->continuous integration: grab browsers, test, exit
  ;
