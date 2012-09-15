#! /bin/sh

/usr/local/bin/appledoc \
--project-name "GVCUIKit" \
--project-company "Global Village Consulting" \
--company-id "net.global-village" \
--docset-atom-filename "GVCUIKit.atom" \
--docset-feed-url "http://global-village.net/GVCUIKit/%DOCSETATOMFILENAME" \
--docset-package-url "http://global-village.net/GVCUIKit/%DOCSETPACKAGEFILENAME" \
--docset-fallback-url "http://global-village.net/GVCUIKit/" \
--output "~/help" \
--publish-docset \
--logformat xcode \
--keep-undocumented-objects \
--keep-undocumented-members \
--keep-intermediate-files \
--no-repeat-first-par \
--no-warn-invalid-crossref \
--ignore "*.m" \
--index-desc "${PROJECT_DIR}/Resources/Licenses/GVC License.md" \
"${PROJECT_DIR}/GVCUIKit"
