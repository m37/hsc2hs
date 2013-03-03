utils/hsc2hs_USES_CABAL = YES
utils/hsc2hs_PACKAGE = hsc2hs

utils/hsc2hs_dist_PROGNAME         = hsc2hs
utils/hsc2hs_dist-install_PROGNAME = hsc2hs

utils/hsc2hs_dist_SHELL_WRAPPER = YES
utils/hsc2hs_dist_INSTALL = NO
utils/hsc2hs_dist_INSTALL_INPLACE = YES

utils/hsc2hs_dist-install_SHELL_WRAPPER = YES
utils/hsc2hs_dist-install_INSTALL = YES
utils/hsc2hs_dist-install_INSTALL_INPLACE = NO

$(eval $(call build-prog,utils/hsc2hs,dist,0))
$(eval $(call build-prog,utils/hsc2hs,dist-install,1))

# After build-prog above
utils/hsc2hs_dist_MODULES += Paths_hsc2hs
utils/hsc2hs_dist-install_MODULES = $(utils/hsc2hs_dist_MODULES)

utils/hsc2hs_template=$(INPLACE_TOPDIR)/template-hsc.h

define utils/hsc2hs_dist_SHELL_WRAPPER_EXTRA
echo 'HSC2HS_EXTRA="$(addprefix --cflag=,$(CONF_CC_OPTS_STAGE0)) $(addprefix --lflag=,$(CONF_GCC_LINKER_OPTS_STAGE0)) -I$(TOP)/includes"' >> "$(WRAPPER)"
endef
define utils/hsc2hs_dist-install_SHELL_WRAPPER_EXTRA
echo 'HSC2HS_EXTRA="$(addprefix --cflag=,$(CONF_CC_OPTS_STAGE1)) $(addprefix --lflag=,$(CONF_GCC_LINKER_OPTS_STAGE1))"' >> "$(WRAPPER)"
endef

ifneq "$(BINDIST)" "YES"

$(hsc2hs_INPLACE) : | $(utils/hsc2hs_template)

# When invoked in the source tree, hsc2hs will try to link in
# extra-libs from the packages, including libgmp.a.  So we need a
# dependency to ensure these libs are built before we invoke hsc2hs:
$(hsc2hs_INPLACE) : $(OTHER_LIBS)

$(utils/hsc2hs_template) : utils/hsc2hs/template-hsc.h | $$(dir $$@)/.
	"$(CP)" $< $@

endif

install: install_utils/hsc2hs_dist_install

.PHONY: install_utils/hsc2hs_dist_install
install_utils/hsc2hs_dist_install: utils/hsc2hs/template-hsc.h
	$(call INSTALL_HEADER,$(INSTALL_OPTS),$<,"$(DESTDIR)$(topdir)")

BINDIST_EXTRAS += utils/hsc2hs/template-hsc.h

