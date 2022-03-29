enum KycDocType {
  driversLicense,
  identityCard,
  passport,
  residencePermit,
  selfie,
}

enum KycDocSide {
  front,
  back,
}

const kycDocTypeSelfie = 'SELFIE';
const kycDocTypePassport = 'PASSPORT';
const kycDocTypeIdentityCard = 'ID';
const kycDocTypeDriversLicense = 'DRIVERS_LICENSE';
const kycDocTypeResidencePermit = 'RESIDENCE_PERMIT';

String _getApiType(KycDocType type) {
  switch (type) {
    case KycDocType.driversLicense:
      return kycDocTypeDriversLicense;

    case KycDocType.identityCard:
      return kycDocTypeIdentityCard;

    case KycDocType.passport:
      return kycDocTypePassport;

    case KycDocType.residencePermit:
      return kycDocTypeResidencePermit;

    case KycDocType.selfie:
      return kycDocTypeSelfie;
  }
}

extension MerapiKycDocType on KycDocType {
  String toMerapiDocType() {
    return _getApiType(this);
  }
}
