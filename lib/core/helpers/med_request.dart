import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart' as HTMLParser;
import 'package:http/http.dart' as http;
import 'package:medical_history/core/locator.dart';
import 'package:medical_history/core/services/logger.dart';
import 'package:xml/xml.dart';

import 'package:medical_history/core/models/temp_med.dart';

///    class MedRequest
///      Utility class to retrieve medication
///      information by medication name.
class MedRequest {
  final Logger _l = locator();
  final String sectionName = 'MedRequest';

  MedRequest() {
    _l.initSectionPref(sectionName);
  }

  List<String> _rxCUIList;
  String _moreInfoUrl;
  List<String> _medDetails;
  List<String> _medWarning;

  String _rxcuiComment;

  ImageInfo _imageInfo;
  String _medName;
  bool _isDataLoaded;

  List<TempMed> meds;

  String get rxcuiComment => _rxcuiComment;
  bool get isDataLoaded => _isDataLoaded;

  String get medName => _medName;

  int get numMeds => meds.length;

  bool get hasWarning => _medWarning.length > 0;

  String get medInfoUrl => _moreInfoUrl;

  List<String> get medDetails => _medDetails;

  List<String> get medWarningDetails => _medWarning;

  ImageInfo get medInfoImage => _imageInfo;

  List<String> get imageURLs {
    if (_imageInfo == null) return [];
    return _imageInfo.urls;
  }

  TempMed med(int index) => meds[index];

  Future<bool> medInfoByName(String medName) async {
    int medCount = 0;
    _rxCUIList = null;
    _moreInfoUrl = null;
    _medDetails = null;
    _medWarning = null;
    _imageInfo = null;
    _isDataLoaded = false;
    _rxcuiComment = null;

    _medName = medName;

    _l.log(sectionName, 'Med request for: $_medName',
        linenumber: _l.lineNumber(StackTrace.current));

    meds = [];

    try {
      _rxCUIList = await _rxCUIbyName(_medName);
    } catch (e) {
      _l.log(sectionName, e.toString(),
          linenumber: _l.lineNumber(StackTrace.current), always: true);
      return _isDataLoaded; // false
    }

    var rxcuiIterator = _rxCUIList.iterator;
    rxcuiIterator.moveNext();
    _rxcuiComment = rxcuiIterator.current;

    String rxcui;
    while (rxcuiIterator.moveNext()) {
      rxcui = rxcuiIterator.current;
      _l.log(sectionName, rxcui, linenumber: _l.lineNumber(StackTrace.current));
      _isDataLoaded = await nextMedInfo(rxcui);
      _l.log(sectionName, '\tGot nextMedInfo', linenumber: _l.lineNumber(StackTrace.current));
      if (_isDataLoaded) {
        meds.add(TempMed(medCount, rxcui, _medName, _medDetails, _medWarning, _imageInfo));
        medCount++;
        _l.log(sectionName, 'Med added: $medCount', linenumber: _l.lineNumber(StackTrace.current));
      } else
        break;
    }
    _l.log(sectionName, 'Med request complete [$_isDataLoaded]: $_medName',
        linenumber: _l.lineNumber(StackTrace.current));
    return _isDataLoaded;
  }

  Future<bool> nextMedInfo(String rxcui) async {
    _moreInfoUrl = null;
    _medDetails = null;
    _medWarning = null;

    try {
      _moreInfoUrl = await _getMedLineLink(rxcui);
      _l.log(sectionName, 'Got MedLine link', linenumber: _l.lineNumber(StackTrace.current));
    } on Exception catch (_) {
      return false;
    }
    if (_moreInfoUrl == null) {
      _l.log(sectionName, 'Get MedLine Link FAILED!!',
          linenumber: _l.lineNumber(StackTrace.current));
      return false;
    }

    Document html;
    try {
      html = await _getMedDetailsHTML(_moreInfoUrl);
      _l.log(sectionName, 'Got med details html', linenumber: _l.lineNumber(StackTrace.current));
    } on Exception catch (_) {
      return false;
    }
    if (html == null) return false;
    try {
      _medDetails = _getMedDetails(html);
      _medWarning = _getMedWarningDetails(html);
      _imageInfo = await _getMedImageInfo(rxcui);
      _l.log(sectionName, 'Got med image info', linenumber: _l.lineNumber(StackTrace.current));
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<List<String>> _rxCUIbyName(String medName) async {
    ///  Query String Fields
    ///  term - the search string
    ///
    ///  maxEntries - (optional, default=20) the maximum number of entries to return
    ///
    ///  option - (optional, default=0) special processing options. Valid values:
    ///      0 - no special processing
    ///      1 - return only information for terms contained in valid RxNorm concepts.
    ///       That is, the term must either be from the RxNorm vocabulary or a synonym
    ///       of a (non-suppressed) term in the RxNorm vocabulary.
    ///
    ///          /approximateTerm?term=$medName
    ///          &maxEntries=yyy&option=z  : Optional
    ///
    ///
    ///      This URL returns XML containing the RXCUI code needed
    ///      to query for med details.
    ///        <candidate>
    ///          <rxcui>17767</rxcui>
    ///          <rxaui>3619747</rxaui>
    ///          <score>25</score>
    ///          <rank>1</rank>
    ///        </candidate>

    String rxnavURLString = "https://rxnav.nlm.nih.gov/REST/";
    String queryString = "approximateTerm?term=";
    String optionsString = "&maxEntries=9&option=1";

    final String url = rxnavURLString + queryString + medName + optionsString;

    final Uri uri = Uri.parse(url);

    _l.log(sectionName, 'URI: $uri', linenumber: _l.lineNumber(StackTrace.current));

    http.Response response;
    try {
      response = await http.get(uri).timeout(Duration(seconds: 15));
    } catch (e) {
      _l.log(sectionName, e.toString(),
          linenumber: _l.lineNumber(StackTrace.current), always: true);
      throw Exception('Did not retrieve RXCUI XML');
    }

    if (response.statusCode == 200) {
      List<String> rxcuiList = [];

      XmlDocument respXML = XmlDocument.parse(response.body.toString());
      var comment = respXML.findAllElements('comment').first.text;
      rxcuiList.add(comment);
      _l.log(sectionName, 'RXNav comment: $comment', linenumber: _l.lineNumber(StackTrace.current));

      var candidates = respXML.findAllElements('candidate');
      for (var candidate in candidates) {
        String rxcuiString = candidate.findElements('rxcui').first.text;
        if (rxcuiList.contains(rxcuiString)) continue;
        rxcuiList.add(rxcuiString);
      }
      return rxcuiList;
    } else {
      throw Exception('Did not retrieve RXCUI XML');
    }
  }

  Future<String> _getMedLineLink(String rxCUI) async {
    //  This URL returns XML containing <entry> elements with a
    //  <link> attribute.  The value of <link> is the URL containing
    //  details for the requested drug.  Parse the returned HTML for
    //  the desired details.
    String medlineURLString = "https://connect.medlineplus.gov/service";
    String medlineQueryString = "?mainSearchCriteria.v.cs=2.16.840.1.113883.6.88";
    String medlineRXCodeString = "&mainSearchCriteria.v.c=$rxCUI";
    String url = medlineURLString + medlineQueryString + medlineRXCodeString;

    http.Response response;
    try {
      response = await http.get(url).timeout(Duration(seconds: 10));
    } on Exception catch (e) {
      _l.log(sectionName, e.toString(),
          linenumber: _l.lineNumber(StackTrace.current), always: true);
      throw Exception('Failed to load MedLine XML');
    }

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the XML.
      XmlDocument respXML = XmlDocument.parse(response.body.toString());

      var entries = respXML.findAllElements('entry');
      if (entries.length == 0) {
        _l.log(sectionName, 'No entry found for $rxCUI',
            linenumber: _l.lineNumber(StackTrace.current));
        return null;
      }
      String link;
      for (var entry in entries) {
        _medName = entry.findAllElements('title').first.text;
        link = entry.findAllElements('link').first.getAttribute('href');
        break;
      }
      return link;
    } else {
      throw Exception('Failed to load MedLine XML');
    }
  }

  Future<Document> _getMedDetailsHTML(String medUrl) async {
    try {
      final response = await http.get(medUrl).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        var html = HTMLParser.parse(response.body.toString());
        return html;
      } else {
        throw Exception('Failed to load Detail HTML');
      }
    } catch (e) {
      _l.log(sectionName, e.toString(),
          linenumber: _l.lineNumber(StackTrace.current), always: true);
      throw Exception('Failed to load Detail HTML');
    }
  }

  List<String> _getMedDetails(Document html) {
    Element infoElement = html.getElementById('section-1');
    List<String> infoList = [];
    if (infoElement != null) {
      for (var node in infoElement.nodes) {
        String detail = node.nodes[0].toString();
        //debugPrint(detail);
        if (detail.startsWith("\"")) detail = detail.substring(1);
        if (detail.endsWith("\"")) detail = detail.substring(0, detail.length - 1);
        infoList.add(detail);
      }
    }

    return infoList;
  }

  List<String> _getMedWarningDetails(Document html) {
    Element infoElement = html.getElementById('section-warning');
    List<String> warningList = [];
    if (infoElement != null) {
      for (var node in infoElement.nodes) {
        String detail = node.nodes[0].toString();
        if (detail == null) continue;
        if (detail.startsWith("\"")) detail = detail.substring(1);
        if (detail.endsWith("\"")) detail = detail.substring(0, detail.length - 1);
        warningList.add(detail);
      }
    }
    return warningList;
  }

  Future<ImageInfo> _getMedImageInfo(String rxcui) async {
    List<String> names = [];
    List<String> urls = [];
    List<String> mfgs = [];
    String url = "https://rximage.nlm.nih.gov/api/rximage/1/rxnav"
        "?rxcui=$rxcui&resolution=600&rLimit=10";

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var decodedJson = json.decode(response.body);
      _l.log(sectionName, '$decodedJson', linenumber: _l.lineNumber(StackTrace.current));
      var rxImageInfo = decodedJson['nlmRxImages'];
      for (var rx in rxImageInfo) {
        _l.log(sectionName, "${rx['imageUrl'].toString()}",
            linenumber: _l.lineNumber(StackTrace.current));
        names.add(rx['name'].toString());
        urls.add(rx['imageUrl'].toString());
        mfgs.add(rx['labeler'].toString());
        _l.log(sectionName, '${rx['labeler'].toString()}',
            linenumber: _l.lineNumber(StackTrace.current));
      }
      if (rxcui == "847232") names.add("Lantus 3ml");
      ImageInfo imageInfo = ImageInfo(names: names, urls: urls, mfgs: mfgs);
      return imageInfo;
    } else {
      throw Exception('Did not retrieve JSON');
    }
  }
}
