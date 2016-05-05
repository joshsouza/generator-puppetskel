'use strict';
var yeoman = require('yeoman-generator');
var chalk = require('chalk');
var yosay = require('yosay');
var path = require('path');
var child_process = require('child_process');
var glob = require("glob")
//var exec = require('exec');

module.exports = yeoman.generators.Base.extend({
  initializing: function() {
    var done = this.async();
    this.defaults = {};
    var me=this;
    var jobs = 2;
    child_process.exec('git config --get user.name',function(error, stdout, stderr){
      me.defaults.name=stdout.trim();
      jobs--;
      if(jobs == 0){
        done();
      }
    });
    child_process.exec('git config --get user.email',function(error, stdout, stderr){
      me.defaults.email=stdout.trim();
      jobs--;
      if(jobs == 0){
        done();
      }
    });
  },
  prompting: function () {
    var done = this.async();

    // Have Yeoman greet the user.
    this.log(yosay(
      'Welcome to my ' + chalk.red('Puppet Skeleton') + ' generator!'
    ));

    var prompts = [{
      type: 'input',
      name: 'moduleName',
      message: 'What is the name of your module?',
      default: process.cwd().split(path.sep).pop()
    },{
      type: 'confirm',
      name: 'targetDirectory',
      message: 'Do you want to put the files in a subdirectory named after this module?',
      default: true
    },{
      type: 'list',
      name: 'puppetVersion',
      message: 'Which version of the testbed would you like (Puppet version)?',
      choices: ['4.x','3.x'],
      default: 3
    },{
      type: 'input',
      name: 'userName',
      message: 'What is your name?',
      default: this.defaults.name
    },{
      type: 'input',
      name: 'userEmail',
      message: 'What is your email?',
      default: this.defaults.email
    }];

    this.prompt(prompts, function (props) {
      this.props = props;
      // To access props later use this.props.someOption;
      done();
    }.bind(this));
  },

  writing: function () {
    var dir='.';
    if(this.props.targetDirectory===true){
        dir=this.props.moduleName;

    }

    var context = {
      pkg:          this.pkg,
      module_name:  this.props.moduleName,
      author_name:  this.props.userName,
      author_email: this.props.userEmail,
      metadata: {
        name: this.props.moduleName,
        full_module_name: this.props.moduleName,
        author: this.props.userEmail
      }
    }
    this._processDirectory('skeleton',dir,context);
    // Anything unique to versions must be broken down into their respective dirs
    // Tried doing a default first then applying version changes, but that prompts for file updates
    // Won't auto-force, due to the possibility of overwriting user changes on second run
    this._processDirectory(this.props.puppetVersion,dir,context);
  },
  _processDirectory: function(source, destination, context){
    var root = path.join(this.sourceRoot(),source);
    var me = this;
    // This block allows for _wrapped_ variables from context to be replaced in diretory names
    var subs = [];
    for(var index in context) {
       if (context.hasOwnProperty(index) &&
            typeof(context[index])=='string'
       ) {
          var contextObj={
            name: index,
            regex: '_'+index+'_',
            replaceWith: context[index]
          };
          subs.push(contextObj);
       }
    }

    // Glob is the way of the future for getting files
    glob('**',{dot:true, cwd: root, nodir: true},function(er, files){
      for (var i = 0; i < files.length; i++) {
        var f = files[i];
        var src = path.join(root, f);
        var base = path.basename(f);
        var baseDir = path.dirname(f);
        for(var idx = 0; idx < subs.length; idx++){
          baseDir = baseDir.replace(subs[idx].regex,subs[idx].replaceWith);
          base = base.replace(subs[idx].regex,subs[idx].replaceWith);
        }
        if(base.indexOf('_') == 0){
          me.log(baseDir+'/'+base);
            base = base.replace(/^_/,'');
            var dest = path.join(destination, baseDir, base);
            me.template(src, dest, context);
        }
        else{
            var dest = path.join(destination, baseDir, base);
            me.copy(src, dest);
        }
      }
    });
  }

});
