### Prerelease Documentation

This prerelease documentation is intended to guide you on the process of installing and using RedPanda prior to the first official release of the project, so you can test and try RedPanda.

#### Prerequisites install

These programs are required in order to build and use RedPanda

- Xcode 8.x (install from AppStore)
- Ruby > 2.2 get it from [rvm](https://rvm.io) or [rbenv](https://github.com/rbenv/rbenv)
- Ruby Gems:
    - Rake
      ```
      gem install rake
      ```
    - Bundler
      ```
      gem install bundler
      ```
    - Cocoapods
      ```
      gem install cocoapods
      ```
    - Fastlane
      ```
      gem install fastlane
      ```

- [Homebrew](http://brew.sh)
    - Ack
      ```
      brew install ack
      ```
    - Rename
      ```
      brew install rename
      ```
    - wget
      ```
      brew install wget
      ```


### Building RedPanda
  In order to build the RedPanda Gem you'll have to install the previously listed programs, then run the following commands:

  ```
  bundle install
  bundle exec rake install
  ```

### Using RedPanda

Then run
```
$ redpanda
1. create
2. exit
Actions:
1
Starting Project Creation Process
What project/application name should be used ?
demo
What bundle id should be used for the project ?
com.redpanda.demo
Creating new project with name: demo
...

```

### Using your project
  You now have a newly created project and are ready to go with it, the following section will showcase what you can do and the various topics and tools provided for you to use.

#### Config/Environments
  Configuration and environments can be a real pain to manage, RedPanda bundles [Natrium](https://github.com/MrCloud/Natrium/) into you project, check the _build-config.yml_ file.

  Your project will initially have the following configurations available:
    - Debug
    - AdHoc
    - Release

  Along with environments:
    - Dev
    - Qualif
    - Preproduction
    - Production

#### Generators
  RedPanda also bundles a generation tool into your project: [Generamba](https://github.com/rambler-digital-solutions/Generamba) in order to ease template-based generation.

  The project is provided with a VIPER template, that can be found in the Templates folder.

  To generate a new VIPER module run:
  ```sh
  generamba gen [MODULE_NAME] swifty_viper
  ```

#### Fastlane
  RedPanda provides some features as Fastlane lanes or Actions:

##### Versioning
  Upon creating your project RedPanda will also enforce some best practices, such as using the GitFlow workflow for versioning:

  Your project will be initialized with a _master_ and _develop_ branch created. And a proper _.gitignore_ file will be added and init commit performed

  Configure your remote and you're good to go:
  ```
  git remote add origin [REPO_URL]
  git push -u origin --all
  ```

##### Packaging
  RedPanda also generates lanes for your project in order to help you package and export your application, you are responsible for correctly providing signing configuration to the project:
  - _test_: runs the tests for the project
      ```
      fastlane test
      ```
  - _build_adhoc_: builds and export the AdHoc version of the app (the environment can be specified with the _environment:_ option)
      ```
      fastlane build_adhoc environment:Production
      ```
  - _testflight_beta_upload_: builds and upload your application on TestFlight
      ```
      fastlane testflight_beta_upload
      ```
  - _build_appstore_: builds and export the AppStore version of the application
      ```
      fastlane build_appstore
      ```

  Feel free to customize and update your _Fastfile_ especially if you update the build configs of your project.

##### Delivery (GitFlow + Packaging)
  RedPanda provides _Fastlane_ lanes to manage the release workflow according to [GitFlow](http://nvie.com/posts/a-successful-git-branching-model/). To deliver a version of your application run the following example lane sequence:
  ```
    fastlane init_release version:1.1
    fastlane testflight_beta_upload
    fastlane finish_release version:1.1
  ```

  1. This will create a new _release/1.1_ branch from _develop_, update the version number of the app to _1.1_, commit the changes and push this new branch to the _origin_ remote.
  2. Build and updload the app with the _Release_ build config and _Production_ environment and then upload it to TestFlight.
  3. Then it will finish the release process by merging back your _release/1.1_ branch into _develop_ & _master_, create the _1.1_ tag and push these to the _origin_ remote and then delete the _release/1.1_ branch both locally and remotely.
