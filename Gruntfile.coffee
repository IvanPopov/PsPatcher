module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON "package.json"
    "download-atom-shell":
      version: "0.20.7"
      outputDir: "bin"
    "jade": 
      compile:
        options:
          data:
            debug: true
            timestamp: "<%= grunt.template.today() %>"
        files: 
          "src/web/index.html": "src/web/index.jade"

  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-download-atom-shell'
  grunt.registerTask 'install', 'download-atom-shell'
  grunt.registerTask 'compile', 'jade'
  grunt.registerTask 'default', '', [ 'install' ]
