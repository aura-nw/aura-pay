import 'package:domain/domain.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';

sealed class NFTHelper{
  MediaType getMediaType(NFTInformation nftInformation){
    final offChain = nftInformation.mediaInfo.offChain;
    String nftType = '';

    if(offChain.animation != null){
      nftType = offChain.animation?.contentType ?? '';
    }

    if(nftType.isEmpty){
      nftType = offChain.image.contentType ?? '';
    }

    MediaType mediaType = MediaType.image;

    switch(nftType){
      case 'video/webm':
      case 'video/mp4':
      mediaType = MediaType.video;
        break;
      case 'image/png':
      case 'image/jpeg':
      case 'image/gif':
      case 'application/xml':
      case 'image/svg+xml':
      case 'image/webp':
      case 'image/avif':
      mediaType = MediaType.image;
        break;
      case 'audio/mpeg':
      case 'audio/vnd.wave':
      case 'audio/ogg':
      case 'audio/wav':
        mediaType = MediaType.audio;
        break;
      default:
        mediaType = MediaType.image;
    }

    return mediaType;
  }
}