module.exports = (grunt) ->

  sourceDir = 'source'
  targetDir = 'target'

  everythingElse = [
    '**/*.*'
    '!**/*.styl'
    '!**/*.jade'
    '!**/*.coffee'
  ]

  grunt.initConfig

    clean: [targetDir]

    # Compilers

    stylus:

      all:
        files: [
          expand: true
          cwd: sourceDir
          src: '**/*.styl'
          dest: targetDir
          ext: '.css'
        ]

    jade:

      all:
        files: [
          expand: true
          cwd: sourceDir
          src: '**/*.jade'
          dest: targetDir
          ext: '.html'
        ]

    coffee:

      all:
        files: [
          expand: true
          cwd: sourceDir
          src: [
            '**/*.coffee'
            '!node_modules/**/*.coffee'
            '!Gruntfile.coffee'
          ]
          dest: targetDir
          ext: '.js'
        ]

    # Copy files that do not need compiling

    copy:

      everythingElse:
        files: [
          expand: true
          cwd: sourceDir
          src: everythingElse
          dest: targetDir
        ]

    # Local server

    connect:

      server:
        options:

          port: 9001
          base: [
            ''
            targetDir
          ]
          livereload: true

    # Watching

    watch:

      stylus:
        files: [
          '**/*.styl'
        ]
        tasks: [
          'newer:stylus'
        ]
        options:
          cwd: sourceDir
          livereload: true

      jade:
        files: [
          '**/*.jade'
        ]
        tasks: [
          'newer:jade'
          'wiredep'
          'includeSource'
        ]
        options:
          cwd: sourceDir
          livereload: true

      coffee:
        files: [
          '**/*.coffee'
        ]
        tasks: [
          'newer:coffee'
        ]
        options:
          cwd: sourceDir
          livereload: true

      everythingElse:
        files: everythingElse
        tasks: [
          'newer:copy:everythingElse'
        ]
        options:
          cwd: sourceDir
          livereload: true

      anything:
        files: '**/*.*',
        tasks: ['build']
        options:
          event: ['deleted']
          cwd: sourceDir
          livereload: true

    wiredep:

      task:

        src: [
          'target/index.html'
        ]

    includeSource:
      options:
        basePath: 'target'
        baseUrl: ''
        templates:
          html:
            js: '<script src="{filePath}"></script>'
            css: '<link rel="stylesheet" type="text/css" href="{filePath}" />'

      myTarget:
        files:
          'target/index.html': 'target/index.html'

  grunt.registerTask 'compile', [
    'stylus'
    'jade'
    'coffee'
    'wiredep'
    'includeSource'
  ]

  grunt.registerTask 'build', [
    'clean'
    'compile'
    'copy:everythingElse'
  ]

  grunt.registerTask 'serve', [
    'build'
    'connect:server'
    'watch'
  ]

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-include-source'
  grunt.loadNpmTasks 'grunt-newer'
  grunt.loadNpmTasks 'grunt-wiredep'
