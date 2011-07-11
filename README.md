# RSpec Approvals

Approvals are based on the idea of the *_golden master_*.

You take a snapshot of an object, and then compare all future
versions of the object to the snapshot.

See [ApprovalTests](http://www.approvaltests.com) for videos and additional documentation about the general concept.

The original Approvals libraries for Java and C# were developed by Llewellyn Falco.


## Configuration

The default location for the output files is

    spec/approvals

You can change this using the configuration option

    RSpec.configure do |c|
      c.approvals_path = 'some/other/path'
    end


## Usage

The basic format of the approval is modeled after RSpec's `it`:

    approve "something" do
      "this is the received contents"
    end


The `:to_s` method on the object will be used to generate the output for
the `*.received.txt` file. For custom objects you will need to override
the `to_s` to get helpful output, rather than the default:

    #<Object:0x0000010105ea40> 

The first time the specs are run, two files will be created:

    something.received.txt
    something.approved.txt


Since you have not yet approved anything, the something.approved.txt file is
empty.

The contents of the two files are compared, and the approval will fail at this point.

If the contents of the received file is to your liking, you can approve
the file by overwriting the approved file with the received file.

    mv something.received.txt something.approved.txt

When you rerun the spec, it should now pass.


Copyright (c) 2011 Katrina Owen, released under the MIT license
