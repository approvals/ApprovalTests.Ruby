module Approvals
  class CLI < Thor

    desc "verify", "Go through all failing approvals with a diff tool"
    method_option :diff, :type => :string, :default => 'vimdiff', :aliases => '-d', :desc => 'The difftool to use'
    method_option :ask, :type => :boolean, :default => false, :aliases => "-a", :desc => 'Offer to approve the received file for you.'
    def verify

      approvals = File.read('.approvals').split("\n")

      rejected = []
      approvals.each do |approval|
        system("#{options[:diff]} #{approval}")

        if options[:ask] && yes?("Approve?")
            system("mv #{approval}")
        else
          rejected << approval
        end
      end

      File.open('.approvals', 'w') do |f|
        f.write rejected.join("\n")
      end
    end

  end
end
