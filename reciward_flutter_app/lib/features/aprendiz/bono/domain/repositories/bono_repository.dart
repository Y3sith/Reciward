import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:reciward_flutter_app/features/aprendiz/bono/domain/entities/bono_entity.dart';
import 'package:reciward_flutter_app/features/aprendiz/bono/domain/entities/get_historial_bono.dart';

abstract class BonoRepository {

  Future<Either<DioException, List<BonoEntity>>> getBonos(String accessToken);

  Future<Either<DioException, String>> saveBonoAprendiz(String accessToken, int bonoId);

  Future<Either<DioException, List<GetHistorialBono>>> getHistorialBonos(String accessToken);
}