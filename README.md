# RSpec Approvals

Approvals are based on the idea of the *_golden master_*.

You take a snapshot of an object, and then compare all future
versions of the object to the snapshot.

Big hat tip to Llewellyn Falco who developed the approvals concept, as
well as the original approvals libraries (.NET, Java, Ruby, PHP,
probably others).

See [ApprovalTests](http://www.approvaltests.com) for videos and additional documentation about the general concept.

Also, check out  Herding Code's podcast #117 http://t.co/GLn88R5 in
which Llewellyn Falco is interviewed about approvals.

## Configuration

The default location for the output files is

    spec/approvals

You can change this using the configuration option

    RSpec.configure do |c|
      c.approvals_path = 'some/other/path'
    end


## Usage

The basic format of the approval is modeled after RSpec's `it`:

    verify "something" do
      "this is the received contents"
    end


The `:inspect` method on the object will be used to generate the output for
the `*.received.txt` file. For custom objects you will need to override
the `:inspect` to get helpful output, rather than the default:

    #<Object:0x0000010105ea40> # or whatever the object id is

The first time the specs are run, two files will be created:

    full_description_of_something.received.txt
    full_description_of_something.approved.txt


Since you have not yet approved anything, the `*.approved.txt` file is
empty.

The contents of the two files are compared, and the approval will fail at this point.

### Formatting

You can pass options to format output before it gets written to the file.
At the moment, only xml, html, and json are supported.

Simply add a `:format => :xml`, `:format => :html`, or `:format => :json` option to the example:

    verify "some html", :format => :html do
      "<html><head></head><body><h1>ZOMG</h1></body></html>"
    end

    verify "some json", :format => :json do
      {"beverage" => "coffee"}.to_json
    end


### Approving a spec

If the contents of the received file is to your liking, you can approve
the file by overwriting the approved file with the received file.

For an example who's full description is `My Spec`:

    mv my_spec.received.txt my_spec.approved.txt

When you rerun the spec, it should now pass.


Copyright (c) 2011 Katrina Owen, released under the MIT license
