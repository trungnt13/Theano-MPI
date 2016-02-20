source /opt/sharcnet/testing/set4theano.sh

if [[ -z $1 ]]; then
	echo 'need a host as argument $1'
	exit 1
else
	host=$1
fi

if [[ $2 == 'val' ]]; then
	file='val_mpi.py'
	echo 'validating'
else
	file='worker.py'
	echo 'training'
fi

CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7 \
mpirun --mca btl_smcuda_use_cuda_ipc 1 --mca mpi_common_cuda_cumemcpy_async 1 --prefix /opt/sharcnet/openmpi/1.8.7/intel-15.0.3/std -x PYTHONPATH=$PYTHONPATH -x PATH=$PATH -x CPATH=$CPATH -x LIBRARY_PATH=$LIBRARY_PATH -x LD_LIBRARY_PATH=$LD_LIBRARY_PATH -n 4 -host $host numactl -N 0 python ../exc/"$file" True cudnn -1 \
:      --mca btl_smcuda_use_cuda_ipc 1 --mca mpi_common_cuda_cumemcpy_async 1 --prefix /opt/sharcnet/openmpi/1.8.7/intel-15.0.3/std -x PYTHONPATH=$PYTHONPATH -x PATH=$PATH -x CPATH=$CPATH -x LIBRARY_PATH=$LIBRARY_PATH -x LD_LIBRARY_PATH=$LD_LIBRARY_PATH -n 4 -host $host numactl -N 1 python ../exc/"$file" True cudnn -1