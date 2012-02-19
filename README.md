# Approvals

Approvals are based on the idea of the *_golden master_*.

You take a snapshot of an object, and then compare all future
versions of the object to the snapshot.

Big hat tip to Llewellyn Falco who developed the approvals concept, as
well as the original approvals libraries (.NET, Java, Ruby, PHP,
probably others).

See [ApprovalTests](http://www.approvaltests.com) for videos and additional documentation about the general concept.

Also, check out  Herding Code's [podcast #117](http://t.co/GLn88R5) in
which Llewellyn Falco is interviewed about approvals.

[![Build Status](https://secure.travis-ci.org/kytrinyx/rspec-approvals.png?branch=master)](http://travis-ci.org/kytrinyx/rspec-approvals)

## Configuration

    Approvals.configure do |c|
      c.approvals_path = 'output/goes/here/'
    end

The default location for the output files is

    approvals/

## Usage

    Approvals.verify(your_subject, :format => :json)

This will raise an `ApprovalError` in the case of a failure.

The `:inspect` method on the subject will be used to generate the output for
the `received` file. For custom complex objects you will need to override
`:to_s` or `:inspect` to get helpful output, rather than the default:

    #<Object:0x0000010105ea40> # or whatever the object id is

Note: `:inspect` uses `:to_s` unless it has been specifically defined to do something else.

The first time the approval is run, a file will be created with the contents of the subject of your approval:

    the_name_of_the_approval.received.txt # or .json, .html, .xml as appropriate

Since you have not yet approved anything, the `*.approved` file does not exist, and the comparison will fail.

### RSpec

For the moment the only direct integration is with RSpec.

The default directory for output files when using RSpec is

    spec/fixtures/approvals/

You can override this:

    RSpec.configure do |c|
      c.approvals_path = 'some/other/path'
    end

The basic format of the approval is modeled after RSpec's `it`:

    verify "something" do
      "this is the the thing you want to verify"
    end

### Naming

Currently there is only an RSpecNamer that takes an example (or any object that responds to `:full_description`).

    namer = Approvals::Namers::RSpecNamer.new(example)

    Approvals.verify(thing, :namer => namer, :format => :html)

When using RSpec, the namer is set for you.

### Formatting

You can pass a format for your output before it gets written to the file.
At the moment, only xml, html, and json are supported.

Simply add a `:format => :xml`, `:format => :html`, or `:format => :json` option to the example:

    verify "some html", :format => :html do
      "<html><head></head><body><h1>ZOMG</h1></body></html>"
    end

    verify "some json", :format => :json do
      "{\"beverage\":\"coffee\"}"
    end

### Approving a spec

If the contents of the received file is to your liking, you can approve
the file by renaming it.

For an example who's full description is `My Spec`:

    mv my_spec.received.txt my_spec.approved.txt

When you rerun the approval, it should now pass.

### Expensive computations

The Executable class allows you to perform expensive operations only when the command to execute it changes.

For example, if you have a SQL query that is very slow, you can create an executable with the actual SQL to be performed.

The first time the spec runs, it will fail, allowing you to inspect the results.
If this output looks right, approve the query. The next time the spec is run, it will compare only the actual SQL.

If someone changes the query, then the comparison will fail. Both the previously approved command and the received command will be executed so that you can inspect the difference between the results of the two.

    executable = Approvals::Executable.new(subject.slow_sql) do |output|
        # do something on failure
    end

    Approvals.verify(executable, :options => :here)

### RSpec executable

There is a convenience wrapper for RSpec that looks like so:

    verify "an executable" do
      executable(subject.slow_sql) do |command|
         result = ActiveRecord::Base.connection.execute(command)
         # do something to display the result
      end
    end

Copyright (c) 2011 Katrina Owen, released under the MIT license
