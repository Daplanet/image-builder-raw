#!/usr/bin/env bats
## Raw Image
declare -r image_name="odroid-raw"
declare -r image_path="/${image_name}.img"

@test "Image should exist" {
  [ -f $image_path ]
}

declare -r context="Partition Table"

@test "${context} should have 2 partitions" {
  run "fdisk -l ${image_path} | grep '^/${image_name}'"
  [ "$status" -eq 0 ]
  [ "${lines[@]}" -eq 2 ]
}

@test "${context} should have a boot-partition with a sda1 W95 FAT23 filesystem" {
  match='^.*\.img1 \* .*W95 FAT32 \(LBA\)'
  run "fdisk -l ${image_path} | grep '^/${image_name}'"
  [ "$output" =~ $match ]
}

@test "${context} should have a root-partition with sda2 Linux filesystem" {
  match='^.*\.img2 .*Linux$'
  run "fdisk -l ${image_path} | grep '^/${image_name}'"
  [ "$output" =~ $match ]
}

@test "${context} for partion sda1 starts at sector 3072" {
  match='^.*\.img1\ \* *3072 .*$'
  run "fdisk -l ${image_path} | grep '^/${image_name}'"
  [ "$output" =~ $match ]
}

@test "${context} for partion sda1 is size of 64M" {
  match='^.*\.img1.* 64M  c.*$'
  run "fdisk -l ${image_path} | grep '^/${image_name}'"
  [ "$output" =~ $match ]
}
