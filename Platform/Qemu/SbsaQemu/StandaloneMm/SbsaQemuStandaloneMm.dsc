## @file
#  Standalone MM (UEFI variable service) for QEMU sbsa-ref,
#  running as S-EL0 Secure Partition under TF-A SPM_MM (v2.15, qemu_sbsa).
#
#  Memory layout comes from TF-A plat/qemu/qemu_sbsa/include/platform_def.h:
#    PLAT_QEMU_SP_IMAGE_BASE = BL_RAM_BASE = 0x20002000, size 0x300000
#    Secure UART for MM      = 0x60040000 (QEMU sbsa-ref SECURE_UART_MM)
#
#  Variable store: by default emulated NV (RAM inside the SP) so that every
#  boot starts from a clean, deterministic state (good for fuzzing).
#
#  SPDX-License-Identifier: BSD-2-Clause-Patent
##

[Defines]
  PLATFORM_NAME                  = SbsaQemuStandaloneMm
  PLATFORM_GUID                  = 3C2B7E59-4C6B-4A57-9E61-6A1D1F4B6C21
  PLATFORM_VERSION               = 1.0
  DSC_SPECIFICATION              = 0x0001001C
  OUTPUT_DIRECTORY               = Build/SbsaQemuStandaloneMm
  SUPPORTED_ARCHITECTURES        = AARCH64
  BUILD_TARGETS                  = DEBUG|RELEASE
  SKUID_IDENTIFIER               = DEFAULT
  FLASH_DEFINITION               = Platform/Qemu/SbsaQemu/StandaloneMm/SbsaQemuStandaloneMm.fdf

  DEFINE COMPRESSION_TOOL_GUID   = D42AE6BD-1352-4bfb-909A-CA72A6EAE889
  # CLOSED_MM=TRUE embeds the extracted vendor StandaloneMM modules
  # (closed_firmware/05_pe32_modules/standalonemm) as binary MM_STANDALONE
  # drivers, so their MMI handlers become reachable over SMC by GUID.
  DEFINE CLOSED_MM               = FALSE

!include MdePkg/MdeLibs.dsc.inc

[LibraryClasses]
  BaseLib|MdePkg/Library/BaseLib/BaseLib.inf
  BaseMemoryLib|MdePkg/Library/BaseMemoryLib/BaseMemoryLib.inf
  CacheMaintenanceLib|ArmPkg/Library/ArmCacheMaintenanceLib/ArmCacheMaintenanceLib.inf
  DebugLib|MdePkg/Library/BaseDebugLibSerialPort/BaseDebugLibSerialPort.inf
  DebugPrintErrorLevelLib|MdePkg/Library/BaseDebugPrintErrorLevelLib/BaseDebugPrintErrorLevelLib.inf
  ExtractGuidedSectionLib|StandaloneMmPkg/Library/StandaloneMmExtractGuidedSectionLib/StandaloneMmExtractGuidedSectionLib.inf
  HobLib|StandaloneMmPkg/Library/StandaloneMmHobLib/StandaloneMmHobLib.inf
  HobPrintLib|MdeModulePkg/Library/HobPrintLib/HobPrintLib.inf
  IoLib|MdePkg/Library/BaseIoLibIntrinsic/BaseIoLibIntrinsic.inf
  MemLib|StandaloneMmPkg/Library/StandaloneMmMemLib/StandaloneMmMemLib.inf
  MemoryAllocationLib|StandaloneMmPkg/Library/StandaloneMmCoreMemoryAllocationLib/StandaloneMmCoreMemoryAllocationLib.inf
  MmServicesTableLib|MdePkg/Library/StandaloneMmServicesTableLib/StandaloneMmServicesTableLib.inf
  PcdLib|MdePkg/Library/BasePcdLibNull/BasePcdLibNull.inf
  PeCoffLib|MdePkg/Library/BasePeCoffLib/BasePeCoffLib.inf
  PrintLib|MdePkg/Library/BasePrintLib/BasePrintLib.inf
  ReportStatusCodeLib|MdePkg/Library/BaseReportStatusCodeLibNull/BaseReportStatusCodeLibNull.inf
  StandaloneMmCoreEntryPoint|ArmPkg/Library/ArmStandaloneMmCoreEntryPoint/ArmStandaloneMmCoreEntryPoint.inf
  StandaloneMmDriverEntryPoint|MdePkg/Library/StandaloneMmDriverEntryPoint/StandaloneMmDriverEntryPoint.inf
  ImagePropertiesRecordLib|MdeModulePkg/Library/ImagePropertiesRecordLib/ImagePropertiesRecordLib.inf
  PeCoffGetEntryPointLib|MdePkg/Library/BasePeCoffGetEntryPointLib/BasePeCoffGetEntryPointLib.inf
  PerformanceLib|MdePkg/Library/BasePerformanceLibNull/BasePerformanceLibNull.inf

  # PL011 (secure UART reserved for MM on sbsa-ref)
  PL011UartClockLib|ArmPlatformPkg/Library/PL011UartClockLib/PL011UartClockLib.inf
  PL011UartLib|ArmPlatformPkg/Library/PL011UartLib/PL011UartLib.inf
  SerialPortLib|ArmPlatformPkg/Library/PL011SerialPortLib/PL011SerialPortLib.inf
  FdtLib|MdePkg/Library/BaseFdtLib/BaseFdtLib.inf

  ArmGenericTimerCounterLib|ArmPkg/Library/ArmGenericTimerPhyCounterLib/ArmGenericTimerPhyCounterLib.inf
  TimerLib|ArmPkg/Library/ArmArchTimerLib/ArmArchTimerLib.inf
  TimeBaseLib|EmbeddedPkg/Library/TimeBaseLib/TimeBaseLib.inf

  # Variable service
  VarCheckLib|MdeModulePkg/Library/VarCheckLib/VarCheckLib.inf
  VariableFlashInfoLib|MdeModulePkg/Library/BaseVariableFlashInfoLib/BaseVariableFlashInfoLib.inf
  AuthVariableLib|SecurityPkg/Library/AuthVariableLib/AuthVariableLib.inf

  ArmLib|MdePkg/Library/ArmLib/ArmBaseLib.inf
  StandaloneMmMmuLib|ArmPkg/Library/StandaloneMmMmuLib/ArmMmuStandaloneMmLib.inf
  ArmSmcLib|MdePkg/Library/ArmSmcLib/ArmSmcLib.inf
  ArmSvcLib|MdePkg/Library/ArmSvcLib/ArmSvcLib.inf
  ArmTransferListLib|MdePkg/Library/ArmTransferListLib/ArmTransferListLib.inf
  PeCoffExtraActionLib|StandaloneMmPkg/Library/StandaloneMmPeCoffExtraActionLib/StandaloneMmPeCoffExtraActionLib.inf

[LibraryClasses.common.MM_CORE_STANDALONE]
  HobLib|StandaloneMmPkg/Library/StandaloneMmCoreHobLib/StandaloneMmCoreHobLib.inf
  ArmFfaLib|MdeModulePkg/Library/ArmFfaLib/ArmFfaStandaloneMmCoreLib.inf

[LibraryClasses.common.MM_STANDALONE]
  BaseCryptLib|CryptoPkg/Library/BaseCryptLib/SmmCryptLib.inf
  IntrinsicLib|CryptoPkg/Library/IntrinsicLib/IntrinsicLib.inf
  OpensslLib|CryptoPkg/Library/OpensslLib/OpensslLib.inf
  RngLib|MdePkg/Library/BaseRngLibTimerLib/BaseRngLibTimerLib.inf
  PlatformSecureLib|SecurityPkg/Library/PlatformSecureLibNull/PlatformSecureLibNull.inf
  SynchronizationLib|MdePkg/Library/BaseSynchronizationLib/BaseSynchronizationLib.inf
  SafeIntLib|MdePkg/Library/BaseSafeIntLib/BaseSafeIntLib.inf
  MemoryAllocationLib|StandaloneMmPkg/Library/StandaloneMmMemoryAllocationLib/StandaloneMmMemoryAllocationLib.inf

[PcdsFeatureFlag]
  gEfiMdeModulePkgTokenSpaceGuid.PcdSupportUpdateCapsuleReset|FALSE
  # Secure Boot: even in Setup Mode the first PK must be a correctly
  # self-signed EFI_VARIABLE_AUTHENTICATION_2 payload (default FALSE accepts
  # any PK without checking the signature).
  gEfiMdeModulePkgTokenSpaceGuid.PcdRequireSelfSignedPk|TRUE

[PcdsFixedAtBuild]
!if $(TARGET) == RELEASE
  gEfiMdePkgTokenSpaceGuid.PcdDebugPropertyMask|0x21
!else
  gEfiMdePkgTokenSpaceGuid.PcdDebugPropertyMask|0x2f
!endif
  gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel|0x800000CF
  gEfiMdePkgTokenSpaceGuid.PcdDebugClearMemoryValue|0xAF

  ## PL011 - SECURE_UART_MM on sbsa-ref (3rd -serial)
  gEfiMdeModulePkgTokenSpaceGuid.PcdSerialRegisterBase|0x60040000
  gEfiMdePkgTokenSpaceGuid.PcdUartDefaultBaudRate|115200
  gArmPlatformTokenSpaceGuid.PL011UartClkInHz|24000000
  gEfiMdePkgTokenSpaceGuid.PcdMaximumGuidedExtractHandler|0x2

  gEfiMdeModulePkgTokenSpaceGuid.PcdMaxVariableSize|0x2000
  gEfiMdeModulePkgTokenSpaceGuid.PcdMaxAuthVariableSize|0x2800
  gEfiMdeModulePkgTokenSpaceGuid.PcdVariableStoreSize|0x10000

  # Variable store lives in SP RAM (no flash driver needed).
  gEfiMdeModulePkgTokenSpaceGuid.PcdEmuVariableNvModeEnable|TRUE

  gEfiMdeModulePkgTokenSpaceGuid.PcdFfaLibConduitSmc|FALSE

  # BFV is loaded into RAM by TF-A, no shadow copy needed.
  gStandaloneMmPkgTokenSpaceGuid.PcdShadowBfv|FALSE

[Components.common]
  ArmPkg/Library/ArmStandaloneMmCoreEntryPoint/ArmStandaloneMmCoreEntryPoint.inf
  StandaloneMmPkg/Core/StandaloneMmCore.inf {
    <LibraryClasses>
      NULL|MdeModulePkg/Library/LzmaCustomDecompressLib/LzmaCustomDecompressLib.inf
  }
  ArmPkg/Drivers/StandaloneMmCpu/StandaloneMmCpu.inf

  MdeModulePkg/Universal/Variable/RuntimeDxe/VariableStandaloneMm.inf {
    <LibraryClasses>
      DevicePathLib|MdePkg/Library/UefiDevicePathLib/UefiDevicePathLibBase.inf
      NULL|MdeModulePkg/Library/VarCheckUefiLib/VarCheckUefiLib.inf
      NULL|MdeModulePkg/Library/VarCheckPolicyLib/VarCheckPolicyLibStandaloneMm.inf
      BaseMemoryLib|MdePkg/Library/BaseMemoryLib/BaseMemoryLib.inf
      VariablePolicyLib|MdeModulePkg/Library/VariablePolicyLib/VariablePolicyLib.inf
      VariablePolicyHelperLib|MdeModulePkg/Library/VariablePolicyHelperLib/VariablePolicyHelperLib.inf
  }

[BuildOptions.AARCH64]
  GCC:*_*_*_DLINK_FLAGS = -z common-page-size=0x1000
  GCC:*_*_*_CC_FLAGS = -mstrict-align

[BuildOptions.AARCH64.EDKII.MM_CORE_STANDALONE, BuildOptions.AARCH64.EDKII.MM_STANDALONE]
  GCC:*_*_*_DLINK_FLAGS = -z common-page-size=0x1000
