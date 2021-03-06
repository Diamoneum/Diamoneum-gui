# Qt5

set(CMAKE_AUTOMOC ON) # Instruct CMake to run moc automatically when needed
set(CMAKE_AUTOUIC ON) # Create code from a list of Qt designer ui files
set(CMAKE_AUTORCC ON) # Automatically handle Qt resource files

if(CMAKE_VERSION VERSION_LESS "3.7.0")
    # Find includes in corresponding build directories (required by Qt5 moc tool)
    set(CMAKE_INCLUDE_CURRENT_DIR ON)
endif()

if(EXISTS "${Qt5_DIR}" AND IS_DIRECTORY "${Qt5_DIR}")
    message(STATUS "Qt5_DIR is set. Using precompiled Qt5.")
    message(STATUS "Qt5_DIR path: ${Qt5_DIR}")
elseif(EXISTS "$ENV{Qt5_DIR}" AND IS_DIRECTORY "$ENV{Qt5_DIR}")
    message(STATUS "Qt5_DIR is set. Using precompiled Qt5.")
    message(STATUS "ENV{Qt5_DIR} path: $ENV{Qt5_DIR}")
else()
    message(STATUS "Qt5_DIR is not set. Trying to guess Qt5 path...")
endif()

if(NOT DEFINED Qt5_COMPONENTS)
    # Default Qt5 modules
    message(STATUS "Qt5_COMPONENTS is not set. Initializing with default value.")
    set(Qt5_COMPONENTS Core Gui)
endif()
find_package(Qt5 REQUIRED COMPONENTS ${Qt5_COMPONENTS})
find_package(Qt5 COMPONENTS Widgets REQUIRED)
find_package(Qt5LinguistTools)
find_package(Qt5 COMPONENTS Network REQUIRED)

if(TARGET Qt5::qmake)
    get_target_property(QT_QMAKE_EXECUTABLE Qt5::qmake IMPORTED_LOCATION)
    get_filename_component(QT_INSTALL_BINS "${QT_QMAKE_EXECUTABLE}" DIRECTORY)
    get_filename_component(QT_INSTALL_LIBS "${QT_INSTALL_BINS}/../lib" ABSOLUTE)
    get_filename_component(QT_INSTALL_PLUGINS "${QT_INSTALL_BINS}/../plugins" ABSOLUTE)
    message(STATUS "Qt5 qmake path: ${QT_QMAKE_EXECUTABLE}")
    message(STATUS "QT_INSTALL_BINS: ${QT_INSTALL_BINS}")
    message(STATUS "QT_INSTALL_LIBS: ${QT_INSTALL_LIBS}")
    message(STATUS "QT_INSTALL_PLUGINS: ${QT_INSTALL_PLUGINS}")

    if(EXISTS "${QT_INSTALL_BINS}/androiddeployqt")
        add_executable(Qt5::androiddeployqt IMPORTED)

        set_target_properties(
            Qt5::androiddeployqt
            PROPERTIES IMPORTED_LOCATION "${QT_INSTALL_BINS}/androiddeployqt"
        )
        set(Qt5_androiddeployqt_FOUND TRUE)

        message(STATUS "Found androiddeployqt ${QT_INSTALL_BINS}/androiddeployqt")
    elseif(EXISTS "${QT_INSTALL_BINS}/linuxdeployqt")
        # Custom tool. More info at https://github.com/probonopd/linuxdeployqt
        add_executable(Qt5::linuxdeployqt IMPORTED)

        set_target_properties(
            Qt5::linuxdeployqt
            PROPERTIES IMPORTED_LOCATION "${QT_INSTALL_BINS}/linuxdeployqt"
        )
        set(Qt5_linuxdeployqt_FOUND TRUE)

        message(STATUS "Found linuxdeployqt ${QT_INSTALL_BINS}/linuxdeployqt")
    elseif(EXISTS "${QT_INSTALL_BINS}/macdeployqt")
        add_executable(Qt5::macdeployqt IMPORTED)

        set_target_properties(
            Qt5::macdeployqt
            PROPERTIES IMPORTED_LOCATION "${QT_INSTALL_BINS}/macdeployqt"
        )
        set(Qt5_macdeployqt_FOUND TRUE)

        message(STATUS "Found macdeployqt ${QT_INSTALL_BINS}/macdeployqt")
    elseif(EXISTS "${QT_INSTALL_BINS}/windeployqt.exe")
        add_executable(Qt5::windeployqt IMPORTED)

        set_target_properties(
            Qt5::windeployqt
            PROPERTIES IMPORTED_LOCATION "${QT_INSTALL_BINS}/windeployqt.exe"
        )
        set(Qt5_windeployqt_FOUND TRUE)

        message(STATUS "Found windeployqt ${QT_INSTALL_BINS}/windeployqt.exe")
    else()
        # This is not an error! Some platforms don't have this tool.
        message(STATUS "Qt5 deployment tool (macdeployqt, windeployqt or similar) is not found.")
    endif()
endif()
