# RSpec Approvals

Approvals are based on the idea of the *_golden master_*.

You take a snapshot of an object, and then compare all future
versions of the object to the snapshot.

See [ApprovalTests](http://www.approvaltests.com) for videos and additional documentation about the general concept.

The original Approvals libraries for Java and C# were developed by Llewellyn Falco.

One of the areas where approvals come in very handy, is when you have
code without tests that you need to make changes to, and where those
changes are going to be difficult to make without changing the structure
of the program first (i.e. _refactoring_).

From Fields, Harvie, and Fowler, _Refactoring, Ruby Edition_:
> Because the statement result produces a string, I create a few
> customers, give each customer a few rentals of various kinds of films,
> and generate the statement strings. I then do a string comparison
> between the new string and some reference strings that I have hand
> checked.

Approvals make this type of checking against reference strings extremely
simple to do.

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
the `:to_s` to get helpful output, rather than the default:

    #<Object:0x0000010105ea40>

The first time the specs are run, two files will be created:

    full_description_of_something.received.txt
    full_description_of_something.approved.txt


Since you have not yet approved anything, the `*.approved.txt` file is
empty.

The contents of the two files are compared, and the approval will fail at this point.

### Approving a spec

If the contents of the received file is to your liking, you can approve
the file by overwriting the approved file with the received file.

For an example who's full description is `My Spec`:

    mv my_spec.received.txt my_spec.approved.txt

When you rerun the spec, it should now pass.

### Formatters

You can specify a custom formatter when you run the specs.

E.g.

    rspec --require /path/to/lib/rspec/approvals/formatters/opendiff_formatter.rb \
    -f RSpec::Approvals::Formatters::OpendiffFormatter spec/

The OpendiffFormatter automatically launches opendiff for each failed
approval. It falls back on the ProgressFormatter for all non-approval
specs.

That's pretty unweildy, so I'm looking at options to add shortcuts for
this.



Copyright (c) 2011 Katrina Owen, released under the MIT license
