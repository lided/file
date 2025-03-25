#!/bin/bash

# 修改文件名(不包括后缀)为MD5值
# eg rename.sh [filename]

if [ "$#" -ne 1 ]; then
	echo "must give a filename or dirname"
	exit 1
fi

function rename_file_to_md5(){
	file=$1
	bname=$(basename $file)
        extension="${bname##*.}"
	# 计算文件的MD5哈希值
	md5sum=$(md5sum "$file" | awk '{print $1}')
	# 获取文件所在的目录
	dirpath="$(dirname "$file")"
	# 重命名文件
	mv "$file" "$dirpath/$md5sum.$extension" && echo "File $1 renamed to: $md5sum.$extension"
}

if [ -f $1  ]; then
	rename_file_to_md5 $1
	exit 1
elif [ -d $1 ]; then
	for i in `find $1  ! -path '*/.*' -type f`
	do
		rename_file_to_md5 $i
	done
fi
