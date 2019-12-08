# ----------------------------------------------------------------------
# What are the shared memory limits?
#=
$ ipcs -lm --human

------ Shared Memory Limits --------
max number of segments = 4096
max seg size = 16E
max total shared memory = 16E
min seg size = 1B
=#

# another way
#=
$ sysctl kernel.shmmni kernel.shmall kernel.shmmax
kernel.shmmni = 4096
kernel.shmall = 18446744073692774399
kernel.shmmax = 18446744073692774399
=#

# ----------------------------------------------------------------------
# How to adjust?

#=
$ sudo sysctl -w kernel.shmmax=137438953472

$ sysctl kernel.shmmax
kernel.shmmax = 137438953472
=#

# ----------------------------------------------------------------------
# Current size of /dev/shm

#=
$ df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs         16G     0   16G   0% /dev
tmpfs            16G     0   16G   0% /dev/shm
tmpfs            16G  448K   16G   1% /run
tmpfs            16G     0   16G   0% /sys/fs/cgroup
/dev/nvme0n1p1   50G   30G   21G  59% /
tmpfs           3.1G     0  3.1G   0% /run/user/1000
=#

# ----------------------------------------------------------------------
# Start new julia process and create a SharedArray

#=
julia> using SharedArrays

julia> A = SharedArray{Float64}(10000,10000);

julia> A[:] = rand(10000, 10000);

julia> varinfo(Main, r"A")
name        size summary
–––– ––––––––––– ––––––––––––––––––––––––––––––––––
A    762.940 MiB 10000×10000 SharedArray{Float64,2}
=#

# Check system again
#=
$ df -h | egrep '(Used|shm)'                                                                                                
Filesystem      Size  Used Avail Use% Mounted on                                                                            
shmfs            16G  763M   16G   5% /dev/shm
=#

# ----------------------------------------------------------------------
# How to add more space
#=
$ sudo mount -t tmpfs shmfs -o size=28g /dev/shm

$ df -h | egrep '(Used|shm)'
Filesystem      Size  Used Avail Use% Mounted on
shmfs            28G     0   28G   0% /dev/shm
=#