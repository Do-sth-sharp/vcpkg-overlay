find_program (GIT git)

set (GIT_URL "https://github.com/Do-sth-sharp/juce-host-dev-kit.git")
set (GIT_REV "74857795da54b1608da1c758d6815bf30d160699")

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
)

vcpkg_cmake_install ()
vcpkg_cmake_config_fixup (PACKAGE_NAME ${PORT} CONFIG_PATH lib/cmake/${PORT})
#vcpkg_copy_pdbs ()

file (REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file (REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file (INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
file (INSTALL "${SOURCE_PATH}/ARA_SDK/ARA_Library/LICENSE.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright-ARASDK)
file (INSTALL "${SOURCE_PATH}/ARAExtension/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright-ARAEXTENSION)
file (INSTALL "${SOURCE_PATH}/libMackieControl/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright-MACKIECONTROL)
file (INSTALL "${SOURCE_PATH}/LICENSE-ASIOSDK.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright-ASIOSDK)
file (INSTALL "${SOURCE_PATH}/LICENSE-VST2SDK.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright-VST2SDK)
file (INSTALL "${SOURCE_PATH}/LICENSE-VST3SDK.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright-VST3SDK)
file (INSTALL "${SOURCE_PATH}/JUCE/LICENSE.md" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright-JUCE)
