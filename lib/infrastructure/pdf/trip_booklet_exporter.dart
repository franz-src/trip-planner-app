import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:trip_planner/entities/entity_trip.dart';
import 'package:trip_planner/infrastructure/presentation/app/intl/app_localizations.dart';

/// Builds printable booklets using the new trip entities.
abstract final class TripBookletExporter {
  /// Returns PDF bytes for the supplied trip and collected memories.
  static Future<Uint8List> generate(
    Trip trip,
    Map<int, Uint8List> personPhotos,
    Map<int, List<Uint8List>> stopPhotos,
    Map<int, String> descriptions,
    AppLocalizations intl,
  ) async {
    final document = pw.Document();
    final brown = PdfColor.fromHex('#8B4513');
    pw.Widget heading(String text) => pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 12),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 24,
          fontWeight: pw.FontWeight.bold,
          color: brown,
        ),
      ),
    );

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        maxPages: 200,
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            '${intl.tripPlanner} · ${context.pageNumber}/${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 9),
          ),
        ),
        build: (context) => [
          pw.Container(
            padding: const pw.EdgeInsets.all(24),
            decoration: pw.BoxDecoration(color: PdfColor.fromHex('#F5EEDC')),
            child: pw.Column(
              children: [
                heading(trip.title),
                pw.Text(
                  '${trip.startDate} - ${trip.endDate} / ${trip.transport}',
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
          ),
          heading(intl.travelGroup),
          pw.Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (var index = 0; index < trip.group.length; index++)
                pw.SizedBox(
                  width: 140,
                  child: pw.Column(
                    children: [
                      pw.Image(
                        pw.MemoryImage(personPhotos[index]!),
                        width: 120,
                        height: 120,
                        fit: pw.BoxFit.cover,
                      ),
                      pw.Text(
                        trip.group[index].name,
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        '${trip.group[index].age} ${intl.yearsOld}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          heading(intl.tripRoute),
          if (trip.mapImage != null && trip.mapImage!.isNotEmpty)
            pw.Image(
              pw.MemoryImage(trip.mapImage!),
              height: 220,
              fit: pw.BoxFit.contain,
            ),
          if (trip.mapImage == null || trip.mapImage!.isEmpty)
            pw.Text(intl.mapNotAvailable),
          for (var index = 0; index < trip.stops.length; index++) ...[
            heading(trip.stops[index].location),
            pw.Text(
              '${trip.stops[index].startDate} - ${trip.stops[index].endDate}',
            ),
            for (final experience in trip.stops[index].stopExperiences)
              pw.Bullet(text: experience.experience),
            heading(intl.ourExperience),
            pw.Text(descriptions[index]!),
            heading(intl.photoGallery),
            for (final photo in stopPhotos[index]!)
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 12),
                child: pw.Image(
                  pw.MemoryImage(photo),
                  height: 200,
                  fit: pw.BoxFit.contain,
                ),
              ),
          ],
          pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Text(
              intl.quote,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(color: brown, fontSize: 16),
            ),
          ),
        ],
      ),
    );

    return await document.save();
  }
}
