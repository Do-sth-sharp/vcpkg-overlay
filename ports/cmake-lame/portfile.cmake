find_program (GIT git)

set (GIT_URL "https://github.com/Do-sth-sharp/cmake-lame.git")
set (GIT_REV "dda85e8f2e1086259c42d33637c5d2e727be8eb9")

set (SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src)

if (EXISTS "${SOURCE_PATH}")
	file (REMOVE_RECURSE "${SOURCE_PATH}")
endif ()
if (NOT EXISTS "${SOURCE_PATH}")
	file (MAKE_DIRECTORY "${SOURCE_PATH}")
endif ()

message (STATUS "Cloning and fetching submodules")
vcpkg_execute_required_process (
	COMMAND ${GIT} clone --recurse-submodules ${GIT_URL} ${SOURCE_PATH}
	WORKING_DIRECTORY ${SOURCE_PATH}
	LOGNAME clone
)

message (STATUS "Checkout revision ${GIT_REV}")
vcpkg_execute_required_process (
	COMMAND ${GIT} checkout ${GIT_REV}
	WORKING_DIRECTORY ${SOURCE_PATH}
	LOGNAME checkout
)
vcpkg_execute_required_process (
	COMMAND ${GIT} submodule update --recursive
	WORKING_DIRECTORY ${SOURCE_PATH}
	LOGNAME submodule-update
)

vcpkg_cmake_configure (
	SOURCE_PATH "${SOURCE_PATH}"
	DISABLE_PARALLEL_CONFIGURE
	OPTIONS
		-DLAME_VCPKG_TOOLS_HINT=ON
)

vcpkg_cmake_install ()
vcpkg_cmake_config_fixup (PACKAGE_NAME ${PORT} CONFIG_PATH lib/cmake/${PORT})
#vcpkg_copy_pdbs ()

file (REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file (REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file (INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
file (INSTALL "${SOURCE_PATH}/lame-3.100/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright-LAME)
