include(ExternalProject)

function(_truchas_tpl_register_package)
  set(one_value_args
    NAME
    DISPLAY_NAME
    STATUS
    VERSION
    URL
    URL_HASH
    GENERATOR
    LIST_SEPARATOR
    ROOT
  )
  set(multi_value_args
    DEPENDS
    CMAKE_ARGS
    PATCH_COMMAND
  )
  cmake_parse_arguments(TTRP
    "" "${one_value_args}" "${multi_value_args}" ${ARGN})

  if(NOT TTRP_NAME)
    message(FATAL_ERROR "_truchas_tpl_register_package requires NAME")
  endif()

  get_property(package_names GLOBAL PROPERTY TRUCHAS_TPL_PACKAGE_NAMES)
  if(NOT TTRP_NAME IN_LIST package_names)
    list(APPEND package_names "${TTRP_NAME}")
    set_property(GLOBAL PROPERTY TRUCHAS_TPL_PACKAGE_NAMES "${package_names}")
  endif()

  if(NOT TTRP_DISPLAY_NAME)
    set(TTRP_DISPLAY_NAME "${TTRP_NAME}")
  endif()
  if(NOT TTRP_STATUS)
    set(TTRP_STATUS "unknown")
  endif()

  set(property_prefix "TRUCHAS_TPL_PACKAGE_${TTRP_NAME}")
  set_property(GLOBAL PROPERTY "${property_prefix}_DISPLAY_NAME" "${TTRP_DISPLAY_NAME}")
  set_property(GLOBAL PROPERTY "${property_prefix}_STATUS" "${TTRP_STATUS}")
  set_property(GLOBAL PROPERTY "${property_prefix}_VERSION" "${TTRP_VERSION}")
  set_property(GLOBAL PROPERTY "${property_prefix}_URL" "${TTRP_URL}")
  set_property(GLOBAL PROPERTY "${property_prefix}_URL_HASH" "${TTRP_URL_HASH}")
  set_property(GLOBAL PROPERTY "${property_prefix}_GENERATOR" "${TTRP_GENERATOR}")
  set_property(GLOBAL PROPERTY "${property_prefix}_ROOT" "${TTRP_ROOT}")
  set_property(GLOBAL PROPERTY "${property_prefix}_DEPENDS" "${TTRP_DEPENDS}")
  set_property(GLOBAL PROPERTY "${property_prefix}_CMAKE_ARGS" "${TTRP_CMAKE_ARGS}")
  set_property(GLOBAL PROPERTY "${property_prefix}_PATCH_COMMAND" "${TTRP_PATCH_COMMAND}")
endfunction()

function(truchas_tpl_external_project)
  set(options)
  set(one_value_args
    NAME
    DISPLAY_NAME
    GENERATOR
    PREFIX
    VERSION
    URL
    URL_HASH
    SOURCE_SUBDIR
  )
  set(multi_value_args
    DEPENDS
    CMAKE_ARGS
    PATCH_COMMAND
    BYPRODUCTS
  )
  cmake_parse_arguments(TTEP
    "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

  if(NOT TTEP_NAME)
    message(FATAL_ERROR "truchas_tpl_external_project requires NAME")
  endif()
  if(NOT TTEP_URL)
    message(FATAL_ERROR "truchas_tpl_external_project(${TTEP_NAME}) requires URL")
  endif()

  set(common_cmake_args
    -D CMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -D CMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
    -D BUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
  )

  if(TTEP_PREFIX)
    set(ep_prefix "${TTEP_PREFIX}")
  else()
    set(ep_prefix "${TTEP_NAME}")
  endif()

  set(ep_args
    PREFIX "${ep_prefix}"
    URL "${TTEP_URL}"
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
    CMAKE_ARGS ${common_cmake_args} ${TTEP_CMAKE_ARGS}
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
  )

  if(TTEP_URL_HASH)
    list(APPEND ep_args URL_HASH "${TTEP_URL_HASH}")
  endif()
  if(TTEP_DEPENDS)
    list(APPEND ep_args DEPENDS ${TTEP_DEPENDS})
  endif()
  if(TTEP_SOURCE_SUBDIR)
    list(APPEND ep_args SOURCE_SUBDIR "${TTEP_SOURCE_SUBDIR}")
  endif()
  if(TTEP_PATCH_COMMAND)
    list(APPEND ep_args PATCH_COMMAND ${TTEP_PATCH_COMMAND})
  endif()
  if(TTEP_BYPRODUCTS)
    list(APPEND ep_args BUILD_BYPRODUCTS ${TTEP_BYPRODUCTS})
  endif()
  if(TTEP_GENERATOR)
    list(APPEND ep_args CMAKE_GENERATOR "${TTEP_GENERATOR}")
  endif()
  if(TTEP_LIST_SEPARATOR)
    list(APPEND ep_args LIST_SEPARATOR "${TTEP_LIST_SEPARATOR}")
  endif()

  _truchas_tpl_register_package(
    NAME "${TTEP_NAME}"
    DISPLAY_NAME "${TTEP_DISPLAY_NAME}"
    VERSION "${TTEP_VERSION}"
    STATUS built
    ROOT "${CMAKE_INSTALL_PREFIX}"
    URL "${TTEP_URL}"
    URL_HASH "${TTEP_URL_HASH}"
    GENERATOR "${TTEP_GENERATOR}"
    DEPENDS ${TTEP_DEPENDS}
    CMAKE_ARGS ${TTEP_CMAKE_ARGS}
    PATCH_COMMAND ${TTEP_PATCH_COMMAND}
  )

  ExternalProject_Add("${TTEP_NAME}" ${ep_args})
  ExternalProject_Add_StepDependencies("${TTEP_NAME}" configure
    truchas_tpl_external_configure_inputs)
endfunction()
