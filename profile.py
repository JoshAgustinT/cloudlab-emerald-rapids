"""
Main things to change in: profile.py, dramhit-setup.sh

profile.py contains: machine used, os version used
dramhit-setup.sh contains: machine startup script
"""	  
# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg

# Create a portal context.
pc = portal.Context()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()

node_0 = request.RawPC('node-0')


# Intel Xeon Gold 6142 Processor
node_0.hardware_type = 'c6420'

# 128 thread dual socket: Intel Xeon Gold 6548Y+
# node_0.hardware_type = 'flex14'
# 1 socket emmerald machine 56 threads
# node_0.hardware_type = 'c6620'

node_0.disk_image = 'urn:publicid:IDN+emulab.net+image+emulab-ops:UBUNTU24-64-STD'
# Install and execute a script that is contained in the repository.
node_0.addService(pg.Execute(shell="sh", command="/local/repository/dramhit-top.sh"))

# Print the generated rspec
pc.printRequestRSpec(request)
