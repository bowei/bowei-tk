# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
ARCH ?= amd64
TAG ?= 1.0
# PREFIX ?= gcr.io/google_containers
PREFIX ?= gcr.io/bowei-gke-dev

IMAGES := \
	bowei-tk \
	bowei-tk-cpu-hog

DOCKER_BUILD_STAMPS := $(IMAGES:=.build.stamp)
DOCKER_PUSH_STAMPS := $(IMAGES:=.push.stamp)

CONTAINER := $(PREFIX)/$(NAME)-$(ARCH):$(TAG)

SRCS := $(shell find . -name \*.go)

all:

images: $(DOCKER_BUILD_STAMPS)

push: $(DOCKER_PUSH_STAMPS)

%.build.stamp: Dockerfile.%
	docker build -t $(PREFIX)/$*-$(ARCH) -f Dockerfile.$* .
	touch $@

%.push.stamp: %.build.stamp
	gcloud docker -- push $(PREFIX)/$*-$(ARCH)
	touch $@

clean:
	rm -f *.stamp

.PHONY: all image push clean
